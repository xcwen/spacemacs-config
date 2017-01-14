;;; typescript-align.el --- Alignment configuration for TYPESCRIPT.

;; Copyright (C) 2011  tetsujin (Yusuke Segawa)

;; Author: tetsujin (Yusuke Segawa) <tetsujin85 (at) gmail.com>
;; Keywords: typescript languages convenience align
;; URL: https://github.com/tetsujin/emacs-typescript-align
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
;; This extension provides alignment for TYPESCRIPT.
;; Note that you must have Font Lock mode enabled.
;;
;; If you don't have typescript-mode then get from https://github.com/rradonic/typescript-mode
;; This typescript-mode has various improvements than original it.
;;
;; Put this file into your load-path.and the following code into your ~/.emacs
;; (add-hook 'typescript-mode-hook
;;           (lambda ()
;;             (require 'typescript-align)
;;             (typescript-align-setup)))

;;; TODO:
;; - Add test codes using el-expectations.

;;; Code:
(require 'typescript-mode)
(require 'align)
(require 'regexp-opt)

(defvar typescript-align-rules-list
  `((typescript-comma-delimiter
     (regexp   . ",\\(\\s-*\\)[^/ \t\n]")
     (repeat   . t)
     (modes    . '(typescript-mode))
     (run-if   . ,(function (lambda () current-prefix-arg))))
    (typescript-assignment
     (regexp   . ,(concat "[^=!^&*-+<>/.| \t\n]\\(\\s-*[=!^&%*-+<>/.|]*\\)[=:]"
                          "\\(\\s-*\\)\\([^= \t\n]\\|$\\)"))
     (group    . (1 2))
     (modes    . '(typescript-mode))
     (justify  . t)
     (tab-stop . nil))
    (typescript-comment
     (regexp   . "\\(\\s-*\\)\\(//.*\\|/\\*.*\\*/\\s-*\\)$")
     (modes    . (typescript-mode))
     (column   . comment-column)
     (valid    . ,(function
                   (lambda ()
                     (save-excursion
                       (goto-char (match-beginning 1))
                       (not (bolp)))))))
    (typescript-chain-logic
     (regexp   . "\\(\\s-*\\)\\(&&\\|||\\|\\<and\\>\\|\\<or\\>\\)")
     (modes    . (typescript-mode))
     (valid    . ,(function
                   (lambda ()
                     (save-excursion
                       (goto-char (match-end 2))
                       (looking-at "\\s-*\\(/[*/]\\|$\\)"))))))
  ))


(defvar typescript-align-region-separate
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
     ;;  beginning of line are some TYPESCRIPT keywrods
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
  "Regexp of a section of TYPESCRIPT for alignment.")

(defun typescript-align-setup ()
  "Setup alignment configuration for TYPESCRIPT code."
  (set (make-local-variable 'align-mode-rules-list) typescript-align-rules-list)
  (set (make-local-variable 'align-region-separate) typescript-align-region-separate)
  (add-to-list 'align-open-comment-modes 'typescript-mode)
  (add-to-list 'align-dq-string-modes 'typescript-mode )
  (add-to-list 'align-sq-string-modes 'typescript-mode )
  )

;; Provide:
(provide 'ts-align)

;;; typescript-align.el ends here
