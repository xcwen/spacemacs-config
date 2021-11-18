;;; company-my-capf.el --- company-mode my-completion-at-point-functions backend -*- lexical-binding: t -*-

;; Copyright (C) 2013-2019, 2021  Free Software Foundation, Inc.

;; Author: Stefan Monnier <monnier@iro.umontreal.ca>

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:
;;
;; The MY-CAPF back-end provides a bridge to the standard
;; my-completion-at-point-functions facility, and thus can support any major mode
;; that defines a proper completion function, including emacs-lisp-mode,
;; css-mode and nxml-mode.

;;; Code:

(require 'company)
(require 'cl-lib)

(defvar my-completion-at-point-functions '(tags-completion-at-point-function)
  "Special hook to find the completion table for the entity at point.
Each function on this hook is called in turn without any argument and
should return either nil, meaning it is not applicable at point,
or a function of no arguments to perform completion (discouraged),
or a list of the form (START END COLLECTION . PROPS), where:
 START and END delimit the entity to complete and should include point,
 COLLECTION is the completion table to use to complete the entity, and
 PROPS is a property list for additional information.
Currently supported properties are all the properties that can appear in
`completion-extra-properties' plus:
 `:predicate'	a predicate that completion candidates need to satisfy.
 `:exclusive'	value of `no' means that if the completion table fails to
   match the text at point, then instead of reporting a completion
   failure, the completion should try the next completion function.
As is the case with most hooks, the functions are responsible for
preserving things like point and current buffer.

NOTE: These functions should be cheap to run since they're sometimes
run from `post-command-hook'; and they should ideally only choose
which kind of completion table to use, and not pre-filter it based
on the current text between START and END (e.g., they should not
obey `completion-styles').")

;; Amortizes several calls to a c-a-p-f from the same position.
(defvar company--my-capf-cache nil)

;; FIXME: Provide a way to save this info once in Company itself
;; (https://github.com/company-mode/company-mode/pull/845).
(defvar-local company-my-capf--current-completion-data nil
  "Value last returned by `company-my-capf' when called with `candidates'.
For most properties/actions, this is just what we need: the exact values
that accompanied the completion table that's currently is use.

`company-my-capf', however, could be called at some different positions during
a completion session (most importantly, by `company-sort-by-occurrence'),
so we can't just use the preceding variable instead.")

(defun company--my-capf-data ()
  (let ((cache company--my-capf-cache))
    (if (and (equal (current-buffer) (car cache))
             (equal (point) (car (setq cache (cdr cache))))
             (equal (buffer-chars-modified-tick) (car (setq cache (cdr cache)))))
        (cadr cache)
      (let ((data (company--my-capf-data-real)))
        (setq company--my-capf-cache
              (list (current-buffer) (point) (buffer-chars-modified-tick) data))
        data))))

(defun company--my-capf-data-real ()
  (cl-letf* (((default-value 'my-completion-at-point-functions)
              ;; Ignore tags-completion-at-point-function because it subverts
              ;; company-etags in the default value of company-backends, where
              ;; the latter comes later.
              (remove 'tags-completion-at-point-function
                      (default-value 'my-completion-at-point-functions)))
             (my-completion-at-point-functions (company--my-capf-workaround))
             (data (run-hook-wrapped 'my-completion-at-point-functions
                                     ;; Ignore misbehaving functions.
                                     #'completion--capf-wrapper 'optimist)))
    (when (and (consp (cdr data)) (integer-or-marker-p (nth 1 data))) data)))

(declare-function python-shell-get-process "python")

(defun company--my-capf-workaround ()
  ;; For http://debbugs.gnu.org/cgi/bugreport.cgi?bug=18067
  (if (or (not (listp my-completion-at-point-functions))
          (not (memq 'python-completion-complete-at-point my-completion-at-point-functions))
          (python-shell-get-process))
      my-completion-at-point-functions
    (remq 'python-completion-complete-at-point my-completion-at-point-functions)))

(defun company-my-capf--save-current-data (data)
  (setq company-my-capf--current-completion-data data)
  (add-hook 'company-after-completion-hook
            #'company-my-capf--clear-current-data nil t))

(defun company-my-capf--clear-current-data (_ignored)
  (setq company-my-capf--current-completion-data nil))

(defvar-local company-my-capf--sorted nil)

(defun company-my-capf (command &optional arg &rest _args)
  "`company-mode' backend using `my-completion-at-point-functions'."
  (interactive (list 'interactive))
  (pcase command
    (`interactive (company-begin-backend 'company-my-capf))
    (`prefix
     (let ((res (company--my-capf-data)))
       (when res
         (let ((length (plist-get (nthcdr 4 res) :company-prefix-length))
               (prefix (buffer-substring-no-properties (nth 1 res) (point))))
           (cond
            ((> (nth 2 res) (point)) 'stop)
            (length (cons prefix length))
            (t prefix))))))
    (`candidates
     (company-my-capf--candidates arg))
    (`sorted
     company-my-capf--sorted)
    (`match
     ;; Ask the for the `:company-match' function.  If that doesn't help,
     ;; fallback to sniffing for face changes to get a suitable value.
     (let ((f (plist-get (nthcdr 4 company-my-capf--current-completion-data)
                         :company-match)))
       (if f (funcall f arg)
         (let* ((match-start nil) (pos -1)
                (prop-value nil)  (faces nil)
                (has-face-p nil)  chunks
                (limit (length arg)))
           (while (< pos limit)
             (setq pos
                   (if (< pos 0) 0 (next-property-change pos arg limit)))
             (setq prop-value (or
                               (get-text-property pos 'face arg)
                               (get-text-property pos 'font-lock-face arg))
                   faces (if (listp prop-value) prop-value (list prop-value))
                   has-face-p (memq 'completions-common-part faces))
             (cond ((and (not match-start) has-face-p)
                    (setq match-start pos))
                   ((and match-start (not has-face-p))
                    (push (cons match-start pos) chunks)
                    (setq match-start nil))))
           (nreverse chunks)))))
    (`duplicates t)
    (`no-cache t)   ;Not much can be done here, as long as we handle
                    ;non-prefix matches.
    (`meta
     (let ((f (plist-get (nthcdr 4 company-my-capf--current-completion-data)
                         :company-docsig)))
       (when f (funcall f arg))))
    (`doc-buffer
     (let ((f (plist-get (nthcdr 4 company-my-capf--current-completion-data)
                         :company-doc-buffer)))
       (when f (funcall f arg))))
    (`location
     (let ((f (plist-get (nthcdr 4 company-my-capf--current-completion-data)
                         :company-location)))
       (when f (funcall f arg))))
    (`annotation
     (company-my-capf--annotation arg))
    (`kind
     (let ((f (plist-get (nthcdr 4 company-my-capf--current-completion-data)
                         :company-kind)))
       (when f (funcall f arg))))
    (`require-match
     (plist-get (nthcdr 4 (company--my-capf-data)) :company-require-match))
    (`init nil)      ;Don't bother: plenty of other ways to initialize the code.
    (`post-completion
     (company--my-capf-post-completion arg))
    ))

(defun company-my-capf--annotation (arg)
  (let* ((f (plist-get (nthcdr 4 company-my-capf--current-completion-data)
                       :annotation-function))
         (annotation (when f (funcall f arg))))
    (if (and company-format-margin-function
             (equal annotation " <f>") ; elisp-completion-at-point, pre-icons
             (plist-get (nthcdr 4 company-my-capf--current-completion-data)
                        :company-kind))
        nil
      annotation)))

(defun company-my-capf--candidates (input)
  (let ((res (company--my-capf-data)))
    (company-my-capf--save-current-data res)
    (when res
      (let* ((table (nth 3 res))
             (pred (plist-get (nthcdr 4 res) :predicate))
             (meta (completion-metadata
                    (buffer-substring (nth 1 res) (nth 2 res))
                    table pred))
             (candidates (completion-all-completions input table pred
                                                     (length input)
                                                     meta))
             (sortfun (cdr (assq 'display-sort-function meta)))
             (last (last candidates))
             (base-size (and (numberp (cdr last)) (cdr last))))
        (when base-size
          (setcdr last nil))
        (setq company-my-capf--sorted (functionp sortfun))
        (when sortfun
          (setq candidates (funcall sortfun candidates)))
        (if (not (zerop (or base-size 0)))
            (let ((before (substring input 0 base-size)))
              (mapcar (lambda (candidate)
                        (concat before candidate))
                      candidates))
          candidates)))))

(defun company--my-capf-post-completion (arg)
  (let* ((res company-my-capf--current-completion-data)
         (exit-function (plist-get (nthcdr 4 res) :exit-function))
         (table (nth 3 res)))
    (if exit-function
        ;; We can more or less know when the user is done with completion,
        ;; so we do something different than `completion--done'.
        (funcall exit-function arg
                 ;; FIXME: Should probably use an additional heuristic:
                 ;; completion-at-point doesn't know when the user picked a
                 ;; particular candidate explicitly (it only checks whether
                 ;; further completions exist). Whereas company user can press
                 ;; RET (or use implicit completion with company-tng).
                 (if (= (car (completion-boundaries arg table nil ""))
                        (length arg))
                     'sole
                   'finished)))))

(provide 'company-my-capf)

;;; company-my-capf.el ends here
