;;; Compiled snippets and support files for `emacs-lisp-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'emacs-lisp-mode
                     '(("d"
                        "(defun $1 ()\n  \"DOCSTRING\"\n  (interactive)\n  (let (var1)\n    (setq var1 some)\n    $0\n  ))"
                        "defun" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/emacs-lisp-mode/d" nil
                        nil)))


;;; Do not edit! File generated at Mon Jun  2 12:24:39 2025
