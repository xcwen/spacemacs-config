;;; js2-align.el --- Alignment configuration for JS2.

;; Copyright (C) 2011  tetsujin (Yusuke Segawa)

;; Author: tetsujin (Yusuke Segawa) <tetsujin85 (at) gmail.com>
;; Keywords: js2 languages convenience align
;; URL: https://github.com/tetsujin/emacs-js2-align
;; Version: 0.0.1

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
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; This extension provides alignment for JS2.
;; Note that you must have Font Lock mode enabled.
;;
;; If you don't have js2-mode then get from https://github.com/rradonic/js2-mode
;; This js2-mode has various improvements than original it.
;;
;; Put this file into your load-path.and the following code into your ~/.emacs
;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (require 'js2-align)
;;             (js2-align-setup)))

;;; TODO:
;; - Add test codes using el-expectations.

;;; Code:
(require 'js2-mode)
(require 'align)
(require 'regexp-opt)

(defvar js2-align-rules-list
  `((js2-comma-delimiter
     (regexp   . ",\\(\\s-*\\)[^/ \t\n]")
     (repeat   . t)
     (modes    . '(js2-mode))
     (run-if   . ,(function (lambda () current-prefix-arg))))
    (js2-assignment
     (regexp   . ,(concat "[^=!^&*-+<>/.| \t\n]\\(\\s-*[=!^&%*-+<>/.|]*\\)[=:]"
                          "\\(\\s-*\\)\\([^= \t\n]\\|$\\)"))
     (group    . (1 2))
     (modes    . '(js2-mode))
     (justify  . t)
     (tab-stop . nil))
    (js2-comment
     (regexp   . "\\(\\s-*\\)\\(//.*\\|/\\*.*\\*/\\s-*\\)$")
     (modes    . (js2-mode))
     (column   . comment-column)
     (valid    . ,(function
                   (lambda ()
                     (save-excursion
                       (goto-char (match-beginning 1))
                       (not (bolp)))))))
    (js2-chain-logic
     (regexp   . "\\(\\s-*\\)\\(&&\\|||\\|\\<and\\>\\|\\<or\\>\\)")
     (modes    . (js2-mode))
     (valid    . ,(function
                   (lambda ()
                     (save-excursion
                       (goto-char (match-end 2))
                       (looking-at "\\s-*\\(/[*/]\\|$\\)"))))))
  ))


(defvar js2-align-region-separate
  (eval-when-compile
    (concat
     ;; blank line
     "\\(?:" "^\\s-*$" "\\)"
     "\\|"
     ;; comment start or end line
     "\\(?:" "^\\s-*\\(?:/[/*]\\|\\*/\\)" "\\)"
     "\\|"
     ;; end of line are '[', '(', '{', '}', '/*'
     "\\(?:" "\\(?:[[({}]\\|/\\*+\\)\\s-*$" "\\)"
     "\\|"
     ;; beginning of line are ')', '}', ']' and trailing character are ',', ';'
     "\\(?:" "^\\s-*[)}]][ \t,;]?\\s-*$" "\\)"
     "\\|"
     ;;  beginning of line are some JS2 keywrods
     "\\(?:"
     "^\\s-*"
     (regexp-opt
      '("for" "while" "if" "else" "switch" "case" "break" "continue"
         "do" "return" ))
     "[ ;]"
     "\\)"
     "\\|"
     ;; function or method call
     "\\(?:" "^\\s-*" "\\(?:" "\\w\\|[.\\: \t]" "\\)+" "(" "\\)"
     ))
  "Regexp of a section of JS2 for alignment.")

(defun js2-align-setup ()
  "Setup alignment configuration for JS2 code."
  (set (make-local-variable 'align-mode-rules-list) js2-align-rules-list)
  (set (make-local-variable 'align-region-separate) js2-align-region-separate)
  (add-to-list 'align-open-comment-modes 'js2-mode)
  (add-to-list 'align-dq-string-modes 'js2-mode)
  (add-to-list 'align-sq-string-modes 'js2-mode)
  )

;; Provide:
(provide 'js2-align)

;;; js2-align.el ends here
