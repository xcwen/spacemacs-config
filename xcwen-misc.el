;;; xcwen-misc.el --- Some basic utility function of xcwen
;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-11 09:53:02 Saturday by taoshanwen>

;; This  file is free  software; you  can redistribute  it and/or
;; modify it under the terms of the GNU General Public License as
;; published by  the Free Software Foundation;  either version 3,
;; or (at your option) any later version.

;; This file is  distributed in the hope that  it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You  should have  received a  copy of  the GNU  General Public
;; License along with  GNU Emacs; see the file  COPYING.  If not,
;; write  to  the Free  Software  Foundation,  Inc., 51  Franklin
;; Street, Fifth Floor, Boston, MA 02110-1301, USA.
(require 's)
(require 'f)
(require 'cl-lib)
(require 'evil)
(require 'multi-term)
(require 'yasnippet)
(require 'xref)
(require 'flycheck)
(require 'ac-php-core)
(require 'treemacs )
(require 'lsp-sqls )
(require 'lsp-eslint)
(require 'sgml-mode)
(require 'multi-vterm)
(require 'phpcbf)
;; (require 'php-mode)
(require 'company)
(require 'flutter)
;;; Commentary:
(defvar term-local-cmd-start-line-regex-str
  "^⎣ $"
  "Doc ,line like:
localhost:~/site-lisp/config$"
  )
;;(eval-when-compile (require 'cl))

(defvar fcitx-remote

  (if (executable-find "fcitx-remote" )
      (executable-find "fcitx-remote" )
    (executable-find "fcitx5-remote" )
    )
  "兼容4 5."
  )


(defun my-s-lower-camel-case (s)
  "Convert S to lowerCamelCase."
  (declare (side-effect-free t))
  (s-join "" (s--mapcar-head 'downcase 'capitalize (my-s-split-words s))))

(defun my-s-upper-camel-case (s)
  "Convert S to UpperCamelCase."
  (declare (side-effect-free t))
  (s-join "" (mapcar 'capitalize (my-s-split-words s))))

(defun check-in-php-mode  ()
  "Check 是否在php mode."
  (or   (string= major-mode "php-mode")
        (string= major-mode "php-ts-mode")
        )
  )
(defun my-s-snake-case (s)
  "Convert S to snake_case."
  (declare (side-effect-free t))
  (s-join "_" (mapcar 'downcase (my-s-split-words s))))


(defun check-file-ts()
  "Doc."
  (interactive)

  (and  (s-ends-with-p ".ts" (buffer-file-name))   )
  )

(defun my-s-split-words (s)
  "Split S into list of words."
  (declare (side-effect-free t))
  (s-split
   "[^a-zA-Z0-9]+"
   (let ((case-fold-search nil))
     (replace-regexp-in-string
      "\\([[:lower:]]\\)\\([[:upper:]]\\)" "\\1 \\2"
      (replace-regexp-in-string "\\([[:upper:]]\\)\\([[:upper:]][0-9[:lower:]]\\)" "\\1 \\2" s)))
   t))

(defun ts-fix-code()
  "Doc  docstring."
  (interactive)
  (let (text)

    (setq  text (buffer-substring-no-properties (- (point) 1) (-  (point) 0 ) ))
    (if (string= text ":" )
        (insert "<any>")
      (insert ":any")
      )
    ;;(message "XXX [%s]" text )
    ))
(defun  multi-term-goto-last-term ()
  "Doc  docstring."
  (interactive)
  (let (find-flag opt-file-name find-path-str init-cmd  line-txt file-path-str)



    (setq opt-file-name   (buffer-file-name)   )
    (when opt-file-name
      (setq opt-file-name  (s-replace-regexp ".*:" ""   opt-file-name )   )
      )

    ;;go to file location dir
    ;;(message "1111")
    (if (and  opt-file-name  (file-exists-p opt-file-name ) )
        (setq file-path-str (file-name-directory opt-file-name ) )
      (setq file-path-str (concat  (getenv "HOME") "/" )))

    ;;(message "1.1")
    ;; (dolist  ( opt-buffer (buffer-list) )

    ;;   ;;(message "1.1.1")
    ;;   (let (check-free-term)
    ;;     (with-current-buffer opt-buffer
    ;;       (setq check-free-term
    ;;             (and
    ;;              ;;term-mode
    ;;              (string= "term-mode" major-mode)
    ;;              ;;本地，处于命令行完成状态
    ;;              (string-match term-local-cmd-start-line-regex-str (buffer-substring-no-properties (line-beginning-position) (line-end-position )))
    ;;              ;;同一个目录
    ;;              (string= file-path-str default-directory )
    ;;                  ))

    ;;       (when  (string= "term-mode" major-mode)
    ;;         (message "check:[%s][%s][%s]<=>[%S], %S %S"
    ;;                  file-path-str
    ;;                  default-directory
    ;;                  major-mode

    ;;                  (string= "term-mode" major-mode)

    ;;                  ;;本地，处于命令行完成状态
    ;;                  (string-match term-local-cmd-start-line-regex-str (buffer-substring-no-properties (line-beginning-position) (line-end-position )))
    ;;                  ;;同一个目录
    ;;                  (string= file-path-str default-directory )

    ;;                  )
    ;;         )
    ;;       )

    ;;     (when check-free-term
    ;;       (switch-to-buffer opt-buffer)
    ;;       (setq find-flag t)
    ;;       (return )
    ;;     ))
    ;;   )

    ;;(message "1.2")
    (let (check-free-term)
      (unless  find-flag
        (cl-dolist  ( opt-buffer (buffer-list) )
          ;;(message "1.2.1 %s " opt-buffer )
          (with-current-buffer opt-buffer
            (setq check-free-term
                  (and
                   ;;term-mode
                   (string= "term-mode" major-mode)
                   ;;本地，处于命令行完成状态
                   (string-match term-local-cmd-start-line-regex-str (buffer-substring-no-properties (line-beginning-position) (line-end-position )))

                   )))

          (when check-free-term
            (switch-to-buffer opt-buffer)
            (setq find-flag t)
            ;;(message "1.2.2: %s" opt-buffer)
            (cl-return ))
          )))


    ;;(message "222")
    (unless find-flag
      (multi-term  ))


    ;;(end-of-buffer)
    ;;(previous-line)
    (setq line-txt (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position )))

    ;;(message "===%s %s" default-directory file-path-str )
    ;;(message "22 ===%s %s"  term-local-cmd-start-line-regex-str line-txt  )
    ;;进入当前文件所在文件夹
    ;; (when (and  (not (string= file-path-str default-directory ))
    ;;             (string-match term-local-cmd-start-line-regex-str line-txt ) ;;本地，处于命令行完成状态
    ;;             )
    (setq init-cmd  (concat "cd '" file-path-str  "' # goto file location   \r" ) )
    ;;(message "send init-cmd :%s " init-cmd )
    (term-send-raw-string init-cmd )
    ;;)
    ))


(defun multi-vterm-goto-last-vterm ()
  "Doc.
Switch to an existing vterm buffer matching the current file directory,
or create a new one."
  (interactive)
  (let (find-flag opt-file-name file-path-str init-cmd line-txt)

    ;; 获取当前文件的路径
    (setq opt-file-name (buffer-file-name))
    (when opt-file-name
      (setq opt-file-name (s-replace-regexp ".*:" "" opt-file-name)))

    ;; 如果文件存在，使用其目录；否则使用 HOME 目录
    (setq file-path-str
          (if (and opt-file-name (file-exists-p opt-file-name))
              (file-name-directory opt-file-name)
            (concat (getenv "HOME") "/")))

    ;; 检查是否存在匹配的 vterm 缓冲区
    (cl-dolist (opt-buffer (buffer-list))
      (with-current-buffer opt-buffer

        (when (and (string= "vterm-mode" major-mode))
          (let ((last-line
                 (save-excursion
                   (goto-char (point-max))
                   (buffer-substring-no-properties
                    (- (line-beginning-position) 10)
                    (line-end-position)))))
            (when (s-matches-p "⎣" last-line )
              (switch-to-buffer opt-buffer)
              (setq find-flag t)

              )
            )
          (cl-return))
        ))

    ;; 如果未找到，创建一个新的 vterm 缓冲区
    (unless find-flag
      (multi-vterm)
      (setq find-flag t))

    (when find-flag
      (setq init-cmd (concat "cd '" file-path-str "' # goto file location"))
      (message "init-cmd:%s" init-cmd)
      (run-with-timer
       0.2 nil
       (lambda ( init-cmd)
         (when (derived-mode-p 'vterm-mode)
           (vterm-insert init-cmd)
           (vterm-send-return))) init-cmd)
      )))

;;   fix test
(defun  tramp-tramp-file-p  ( file-name )
  "Doc FILE-NAME  ."
  nil)

;;; Code:
(defun check-in-linux ()
  "Doc FILE-NAME  ."
  (string= system-type "gnu/linux" )
  )
(defun check-in-mac ()
  "Doc FILE-NAME  ."
  (string= system-type "darwin" )
  )


(defun sudo-save ()
  "Doc  ."
  (interactive)
  (if (not buffer-file-name)
      (write-file (concat "/sudo:root@localhost:" (ido-read-file-name "File:")))
    (write-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun add-to-alist (alist-var elt-cons &optional no-replace)
  "Add to the value of ALIST-VAR an element ELT-CONS if it isn't there yet.
If an element with the same car as the car of ELT-CONS is already present,
replace it with ELT-CONS unless NO-REPLACE is non-nil; if a matching
element is not already present, add ELT-CONS to the front of the alist.
The test for presence of the car of ELT-CONS is done with `equal'."
  (let ((existing-element (assoc (car elt-cons) (symbol-value alist-var))))
    (if existing-element
        (or no-replace
            (rplacd existing-element (cdr elt-cons)))
      (set alist-var (cons elt-cons (symbol-value alist-var)))))
  (symbol-value alist-var))






(defun term-send-esc ()
  "Send ESC in term mode."
  (interactive)
  (term-send-raw-string "\e"))


(defun vterm-send-esc ()
  "Send ESC in term mode."
  (interactive)
  (message "xxxxxxxxxxxxx ")
  )








(defun set-evil-all-state-key ( key func )
  "D. KEY FUNC ."
  (define-key evil-insert-state-map key  func)
  (define-key evil-normal-state-map  key  func )
  (define-key evil-visual-state-map key func)
  (define-key evil-emacs-state-map key func)
  (define-key evil-motion-state-map key func)
  )

(defun set-evil-normal-state-key ( key func )
  "D. KEY FUNC ."
  (define-key evil-normal-state-map key  func )
  )

(defun set-evil-virtual-state-key ( key func )
  "D. KEY FUNC ."
  (define-key evil-visual-state-map key  func )
  )

(defun set-evil-main-state-key (  key func )
  "D. KEY FUNC ."
  (let ()
    (setq key  (concat "," key ))
    (define-key evil-normal-state-map  key  func )
    (define-key evil-visual-state-map key  func )
    (define-key evil-motion-state-map key  func )
    ))


(defun set-evil-main-state-key-on-mode ( mode-map  key func )
  "D. KEY FUNC . MODE-MAP ."
  (setq key  (concat "," key ))
  (evil-define-key 'normal  mode-map  key  func )
  (evil-define-key 'motion mode-map  key  func )
  (evil-define-key 'virtual mode-map  key  func )
  )




(defun set-evil-normal-state-key-on-mode ( mode-map key func )
  "D. MODE-MAP KEY FUNC ."
  (evil-define-key 'normal  mode-map  key  func )
  )

(defun set-evil-normal-or-insert-state-key-on-mode ( mode-map key func )
  "D. MODE-MAP KEY FUNC ."

  (evil-define-key 'normal  mode-map  key  func )
  (evil-define-key 'insert mode-map  key  func )
  )

(defun set-evil-all-state-key-on-mode ( mode-map key func )
  "D. MODE-MAP KEY FUNC ."
  (evil-define-key 'normal  mode-map  key  func )
  (evil-define-key 'insert mode-map  key  func )
  (evil-define-key 'motion mode-map  key  func )
  (evil-define-key 'virtual mode-map  key  func )
  (evil-define-key 'emacs mode-map  key  func )
  )

(defun align-eq ()
  "D."
  (interactive)

  (let ((tmp-mark-pos  (get-mark-pos-ex)))
    (align-regexp (car tmp-mark-pos  ) (cadr tmp-mark-pos  )  "\\(\\s-*\\)[=:]>?" 1 1  )
    (setq tmp-mark-pos  (get-mark-pos-ex))
    (align-regexp (car tmp-mark-pos  ) (cadr tmp-mark-pos  )  "[=:]>?\\(\\s-*\\)" 1 1 )
    ))


(defun ts-get-file-at-point ()
  "D."
  (interactive)
  (let( cur-path  pos-info)
    (save-excursion
      (let (file-name-begin file-name-end file-name  ctrl-name )

        (message "11111111")
        (skip-chars-backward "a-zA-Z0-9._/"   )
        (setq file-name-begin (point))

        (skip-chars-forward "a-zA-Z0-9._/"   )
        (message "333333")

        (setq file-name-end (point))
        (setq cur-path (buffer-substring-no-properties file-name-begin file-name-end ))
        (message "cur-path:%s" cur-path)
        (get-url-path-goto-info cur-path)
        ))
    ))


(defun js-get-file-at-point ()
  "DEFUN."
  (interactive)
  (let( cur-path  pos-info)
    (save-excursion
      (let (file-name-begin file-name-end file-name  ctrl-name )

        (skip-chars-backward "a-zA-Z0-9._/"   )
        (setq file-name-begin (point))

        (skip-chars-forward "a-zA-Z0-9._/"   )

        (setq file-name-end (point))
        (setq cur-path (buffer-substring-no-properties file-name-begin file-name-end ))
        (setq ctrl-name (nth 1  (s-split "/" cur-path  )) )
        (setq file-name ( concat  ctrl-name  ".php" ) )
        (setq pos-info ( concat "/function[ \t]*" (nth 2  (s-split "/" cur-path  ) ) "[ \t]*(" ) )
        (setq cur-path (concat (nth 0  (s-split "/public/" (buffer-file-name)) ) "/app/Http/Controllers/" file-name ))
        (unless (f-exists-p cur-path )
          (setq cur-path (concat (nth 0  (s-split "/\\(new_\\)?vue/" (buffer-file-name)) ) "/app/Http/Controllers/" file-name ))
          )
        ))
    (list cur-path pos-info)
    ))
(defun web-get-file-at-point ()
  "D."
  (interactive)
  (let( cur-path  pos-info)
    (save-excursion
      (let (file-name-begin file-name-end file-name  )

        (skip-chars-backward "a-zA-Z0-9._/"   )
        (setq file-name-begin (point))

        (skip-chars-forward "a-zA-Z0-9._/"   )


        (setq file-name-end (point))
        (setq cur-path (buffer-substring-no-properties file-name-begin file-name-end ))

        (if (s-match "\.js"  cur-path )
            (setq cur-path (concat (nth 0  (s-split "/template/" (buffer-file-name)) ) "/webroot/" cur-path ))
          (progn
            (setq file-name ( concat  (nth 1  (s-split "/" cur-path  )) ".class.php" ) )
            (setq pos-info ( concat "/function.*" (nth 2  (s-split "/" cur-path  )) ) )
            (setq cur-path (concat (nth 0  (s-split "/template/" (buffer-file-name)) ) "/handler/" file-name )))
          )
        ))
    (list cur-path pos-info)
    ))


(defvar cleanup-flag t )
;; (switch-cc-to-h ))))
(defun cleanup-and-goto-error ()
  "DOCSTRING."
  (interactive)

  (let (pos cur-pos )
    (setq cur-pos (point ) )
    (whitespace-cleanup)

    (when  (check-in-php-mode)

      (setq cleanup-flag  (not cleanup-flag ) )
      (when cleanup-flag (phpcbf))
      )
    (when (string= major-mode "vue-mode")
      (if (check-file-ts)
          (progn
            (lsp-eslint-apply-all-fixes)
            )
        (lsp-format-buffer))

      )
    (when (string= major-mode "web-mode")
      (message "xx web-mode"  )
      (sgml-pretty-print 0  (point-max) )
      )



    (whitespace-cleanup)
    (flycheck-buffer)


    (setq  pos (flycheck-next-error-pos 1 t ))
    (if pos
        (progn

          (xref-push-marker-stack)
          (goto-char pos)
          (flycheck-explain-error-at-point)
          )

      (message "No more Flycheck errors: pos:%S, %S" cur-pos (point-max))
      ))
  )
(defun switch-file-opt-ts-url ()
  "D."

  (let(url )
    (setq url (s-trim
               (s-replace
                "\"" ""
                (shell-command-to-string
                 (concat "grep '[ \t]+url[ \t]*=' "  (s-replace ".ts" ".vue" (buffer-file-name))  " |awk -F= '{print $2}'"  )
                 )) ))
    url
    ))
(defun get-url-path-get-fix-path-from-env  (  env-key )
  "D ENV-KEY."
  (s-trim (s-replace  "\"" ""  (shell-command-to-string (concat "grep '^"  env-key  "'  "  (go-core-server--get-project-root-dir ) ".env |awk -F= '{print $2}' "  )  ))
          ))

(defun get-route-jump-file-name  (  sub-path  route-config-str )
  "SUB-PATH, ROUTE-CONFIG-STR."
  (let ((match_path "/" ) route  path kv)
    (cl-dolist  ( item  (s-split ";" route-config-str))
      (setq kv (s-split ":" item))
      (when (=  2 (length kv ))
        (setq route (s-trim (nth 0 kv)) )
        (setq path (s-trim (nth 1 kv)) )
        (when (s-starts-with-p route  sub-path   )
          (setq match_path  path)
          (cl-return)
          )))
    (concat  match_path  sub-path )
    ))


(defun get-url-path-goto-info(url)
  "URL."
  (let (obj-file pos-info  tmp-arr project-name  ctrl-name action-name (server-type "route__default") server-type-str php-file-path)
    (message "server-type:%s" server-type )
    ;;"/route__xx/admin/admin_manage/config_list"
    ;;"/admin/admin_manage/config_list"
    (setq tmp-arr (s-match "\\(/\\(route__[^/]*\\)\\)?\\(/.*\\)" url  ) )
    (when tmp-arr
      (when  (nth 2 tmp-arr)
        (setq server-type (nth 2 tmp-arr) ) )
      (setq url (nth 3 tmp-arr)))
    (setq tmp-arr (s-match "\\(/\\([^/]*\\)\\)?/\\([^/]*\\)/\\([^/]*\\)$" url ) )

    (setq ctrl-name  (nth 3  tmp-arr))
    (setq action-name   (nth 4  tmp-arr))
    (setq project-name  (nth 2  tmp-arr))
    (setq php-file-path  (concat "/" (my-s-upper-camel-case  ctrl-name ) ".php"))
    (when project-name
      (setq php-file-path  (concat "/" (my-s-upper-camel-case  project-name) php-file-path ))
      )
    (cond
     ( (or (string= server-type  "route__menu_similarity")

           )
       (setq  obj-file  (concat (get-url-path-get-fix-path-from-env  "NODE_CONTROLLERS_DIR" ) "/"  project-name "/" ctrl-name ".ts"  ) )
       (setq pos-info ( concat "/async[ \t]+" action-name "[ \t]*("  ) )

       )
     (t
      (setq  obj-file  (concat (get-url-path-get-fix-path-from-env  "PHP_CONTROLLERS_DIR" )  php-file-path ) )
      (setq pos-info ( concat "/function[ \t]+" action-name "[ \t]*("  ) )
      ))

    (message "server-type:%s => %s" server-type obj-file )
    (list  obj-file  pos-info )

    ))
;;(get-url-path-goto-info "/gocore/more_call/test/teacher_list")
;;(get-url-path-goto-info "/test/teacher_list")
;;(get-url-path-goto-info "/core/test/teacher_list")

(defun get-action-switch-to(action )
  "ACTION."
  (let ( switch-flag   (fix (concat "ACTION-SWITCH-TO:"  action ":" )) opt-file line-txt )
    (save-excursion
      (goto-char (point-min))
      (setq switch-flag  (search-forward  fix nil t  ) )

      (when switch-flag
        (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))

        (when (string-match   (concat fix "[ \t]*\\([^ \t]*\\)[ \t]*")   line-txt)
          (setq  opt-file (match-string  1 line-txt))

          (unless (f-exists-p  opt-file )
            (setq opt-file ( get-route-jump-file-name (concat "/"  opt-file ) (get-url-path-get-fix-path-from-env "NEW_VUE_VIEW_DIR") ))
            )

          (unless (f-exists-p  opt-file )
            (setq opt-file ( get-route-jump-file-name (concat "/"  opt-file ) (get-url-path-get-fix-path-from-env "VUE_VIEW_DIR") ))
            )

          )))
    opt-file
    ))

(defun switch-file-opt-proto ()
  "DOCSTRING."
  (interactive)
  (let (  line-txt  opt-file  file-list obj-file check-file-name file-name file-name-fix  (use-default t) pos-info  (goto-gocore-flag nil) project-root-dir  (goto-phpcore-flag nil ) (switch-flag) )
    (save-excursion
      (goto-char (point-min))
      (setq project-root-dir (get-project-root-dir ".env") )
      (setq switch-flag  (search-forward-regexp "[^-]SWITCH-TO:" nil t  ) )

      (when switch-flag
        (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
        (when
            (or (string-match   "SWITCH-TO:[ \t]*\\([^ \t]*\\)[ \t]*"   line-txt)
                (string-match   "SWITCH-TO:.*\"\\([^ \t]*\\)\"[ \t]*"   line-txt)
                )
          (setq  opt-file (match-string  1 line-txt))

          (unless (f-exists-p  opt-file )
            (setq opt-file ( get-route-jump-file-name (concat "/"  opt-file ) (get-url-path-get-fix-path-from-env "NEW_VUE_VIEW_DIR") ))
            )

          (unless (f-exists-p  opt-file )
            (setq opt-file ( get-route-jump-file-name (concat "/"  opt-file ) (get-url-path-get-fix-path-from-env "VUE_VIEW_DIR") ))
            )


          )))

    (if (and opt-file   (file-directory-p  opt-file) )
        (progn ;;目录
          (setq file-name (file-name-nondirectory (buffer-file-name)))
          (setq file-name-fix (file-name-base  file-name))

          (setq file-list (directory-files opt-file))
          (while (and file-list (not obj-file) )
            (setq check-file-name (car file-list) )
            (setq file-list (cdr file-list) )

            (if (and
                 (string= (file-name-base check-file-name ) file-name-fix  ) ;;
                 (not (string= file-name check-file-name   ));;后缀不一样
                 )
                (setq obj-file  (concat opt-file "/" check-file-name) ))))
      (setq obj-file opt-file))
    ;;check for   php html js
    (unless obj-file
      (let ((path-name (buffer-file-name)) ctrl-name action-name tmp-arr path-fix  )
        (cond
         ((check-in-php-mode)
          (progn
            (setq ctrl-name (my-s-snake-case(f-base  (f-base path-name ))) )
            (save-excursion
              (let (line-txt  )
                (ac-php--beginning-of-defun)
                (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                (setq tmp-arr (s-match  ".*function[ \t]+\\([a-zA-Z0-9_]*\\)"  line-txt ) )
                (when tmp-arr
                  (setq action-name (nth 1 tmp-arr) )
                  )))

            ;;phpcore tars
            (when (and (s-match "/app/Controllers/" path-name )  (not (string= action-name "__construct")) )
              (setq tmp-arr (s-match (concat "/app/Controllers/\\(.*\\)/" (f-base path-name)) path-name ))
              (setq path-fix (concat "/" ctrl-name  "__" action-name ".proto"  ) )
              (when tmp-arr
                (setq  path-fix (concat "/" (my-s-snake-case(nth 1 tmp-arr)) path-fix) ))


              (setq obj-file (concat  project-root-dir  "/proto/src"  path-fix )  )
              (message "=======11=%s"  obj-file )
              )
            ))

         )))

    (when obj-file
      (unless (f-exists? obj-file)
        (setq use-default  nil)
        (setq obj-file nil)
        )
      )

    (if obj-file
        (let(line-txt (move-flag t ))
          (find-file obj-file)
          (when pos-info
            (when (string=(substring-no-properties pos-info 0 1 )  "/")


              (when (> (line-number-at-pos )  2)
                (save-excursion
                  (if (check-file-ts )
                      (re-search-backward "[ \t]*public[ \t]+" 0 t 1 )
                    ( evil-backward-section-begin)
                    )
                  (setq line-txt (buffer-substring-no-properties
                                  (line-beginning-position)
                                  (line-end-position )))
                  (when (s-matches-p (substring-no-properties pos-info 1 ) line-txt  ) ;;同一个区域
                    (setq move-flag nil ))
                  ))
              (when move-flag
                (goto-char (point-min))
                (re-search-forward  (substring-no-properties pos-info 1 ) )
                (forward-line))
              )
            ))

      )))

(defun my-jump-merber-class()
  "DOCSTRING."
  (interactive)
  (let ((tags-data (ac-php-get-tags-data))
        symbol-ret check-class-list  class-name inherit-map class-map z-class-name class-member-list  file-list  tmp-arr jump-pos function-map  tmp-ret )

    (setq inherit-map (ac-php-g--inherit-map tags-data))
    (setq class-map (ac-php-g--class-map tags-data))
    (setq function-map (ac-php-g--function-map tags-data))
    (setq symbol-ret (ac-php-find-symbol-at-point-pri tags-data))

    ;;(message  "KKKK:%S " symbol-ret )

    (setq class-name (nth 2 symbol-ret))

    (setq tmp-ret (ac-php--get-item-from-funtion-map class-name  function-map))

    ;;(message "===== %S" tmp-ret)


    (setq tmp-arr (s-split ":" (aref  tmp-ret  3 )))
    (setq file-list (ac-php-g--file-list tags-data))
    (setq jump-pos
          (concat
           (aref file-list (string-to-number (nth 0 tmp-arr )))
           ":" (nth 1 tmp-arr)))

    (ac-php-location-stack-push)
    ;;(message "jump-pos :%S" jump-pos)
    (ac-php-goto-location jump-pos)

    )
  )


(defun my-jump-table-sql()
  "DOCSTRING."
  (interactive)
  (let ((tags-data (ac-php-get-tags-data))
        symbol-ret check-class-list  class-name inherit-map class-map z-class-name class-member-list  file-list  tmp-arr jump-pos )

    (setq inherit-map (ac-php-g--inherit-map tags-data))
    (setq class-map (ac-php-g--class-map tags-data))
    (setq symbol-ret (ac-php-find-symbol-at-point-pri tags-data))
    (message  "KKKK:%S " symbol-ret )

    (setq class-name (nth 2 symbol-ret))
    (setq check-class-list (ac-php--get-check-class-list class-name inherit-map class-map))
    (setq z-class-name (nth 1 check-class-list ))


    (setq class-member-list (gethash z-class-name class-map))



    (setq tmp-arr (s-split ":" (aref  (aref   class-member-list 0 ) 3 )))
    (setq file-list (ac-php-g--file-list tags-data))
    (setq jump-pos
          (concat
           (aref file-list (string-to-number (nth 0 tmp-arr )))
           ":" (nth 1 tmp-arr)))

    (ac-php-location-stack-push)
    (message "jump-pos :%S" jump-pos)
    (ac-php-goto-location jump-pos)
    (re-search-forward  "CREATE TABLE" )

    )
  )

(defvar  show-baidu-dict-flag nil)

(defvar  show-baidu-dict-cur-point nil)
(defvar  my-keyboard-input-dev "")


(defun show-baidu-dict-close()
  "D."
  (when  show-baidu-dict-flag

    (shell-command-to-string (concat "/home/jim/desktop/key_send/send_baidu_dict  " my-keyboard-input-dev "  0") )
    (setq show-baidu-dict-flag nil)
    )
  )
(defun show-baidu-dict-at-region()
  "DOCSTRING."
  (interactive)
  (let ( (cur-evil-visual-state-flag (evil-visual-state-p) )  )
    (setq show-baidu-dict-flag t   )
    (setq show-baidu-dict-cur-point (point) )
    (unless  cur-evil-visual-state-flag
      ;;(save-excursion
      (evil-backward-word-begin )
      (evil-visual-state)
      (evil-forward-word-end )
      ;;)
      )
    (shell-command-to-string (concat "/home/jim/desktop/key_send/send_baidu_dict  " my-keyboard-input-dev "  1") )
    (if cur-evil-visual-state-flag
        (evil-normal-state)
      (progn
        (run-at-time 1 nil
                     #'(lambda()
                         (evil-normal-state)
                         (goto-char show-baidu-dict-cur-point)
                         ))

        )
      )
    ))

(defun send-pot-request ( data )
  "Send  DATA to  pot."
  (let ((url-request-method "POST")
        (url-request-data data))
    (url-retrieve "http://127.0.0.1:60828"
                  (lambda (status)
                    (when (plist-get status :error)
                      (message "Error: %s" (plist-get status :error)))
                    )
                  nil t t)))

(defun show-pot-dict-at-region()
  "DOCSTRING."
  (interactive)
  (let ( text reg-begin-pos  reg-end-pos  tmp-mark-pos  (cur-evil-visual-state-flag (evil-visual-state-p) )  )
    (when cur-evil-visual-state-flag
      (setq reg-begin-pos (region-beginning))
      (setq reg-end-pos (region-end))
      (setq  text (buffer-substring-no-properties reg-begin-pos reg-end-pos) )
      )
    (unless  reg-begin-pos
      (setq text (ac-php--get-cur-word) )
      )
    (setq text  (s-trim text  ) )
    ;; (setq text (concat (s-trim text  ) "\n" ))

    (unless(string=  text "" )
      (send-pot-request text)
      )
    ))


(defun switch-file-opt-ctrl-to-vue-or-profile ( project-root-dir project-name ctrl-name action-name)
  "DOCSTRING.
PROJECT-NAME, PROJECT-ROOT-DIR CTRL-NAME, ACTION-NAME."
  (let(
       obj-file
       (view-file-name (concat "/" project-name "/" ctrl-name "/" action-name ".ts"  ) )
       (profile-file-name (concat "/" project-name "/" ctrl-name "/" action-name ".ts"  ) )
       )

    (setq obj-file ( get-route-jump-file-name view-file-name (get-url-path-get-fix-path-from-env "VUE_VIEW_DIR") ))

    (unless (f-exists-p  obj-file  ) ;;to protobuf
      (setq obj-file (concat  project-root-dir  "/proto/src/" project-name "/" ctrl-name "__" action-name ".proto" )  )
      )
    (message "switch-file-opt-ctrl-to-vue-or-profile:%s" obj-file )
    (list obj-file nil)
    )
  )

(defun switch-file-opt-node-ctrl ( project-root-dir path-name)
  "DOCSTRING. PROJECT-ROOT-DIR. PATH-NAME."
  (let (project-name tmp-arr ctrl-name action-name line-txt    )
    ;;TODO NODE CORE
    (setq tmp-arr (s-match  "/controllers/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).ts"  path-name ))
    (setq  ctrl-name   (nth 2 tmp-arr) )
    (setq  project-name (nth 1 tmp-arr) )

    (save-excursion
      (search-backward-regexp "^[ \t]+async[ \t]"  )
      (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
      (setq tmp-arr (s-match  ".*async[ \t]+\\([a-zA-Z0-9_]*\\)"  line-txt ) )
      (when tmp-arr
        (setq action-name (nth 1 tmp-arr) )
        ))
    (if action-name
        (switch-file-opt-ctrl-to-vue-or-profile project-root-dir project-name ctrl-name  action-name)
      (list nil nil)
      )
    )
  )
(defun switch-file-opt ()
  "DOCSTRING."
  (interactive)
  (let (  line-txt  opt-file  file-list obj-file check-file-name file-name file-name-fix  (use-default t) pos-info  (goto-gocore-flag nil)  (goto-phpcore-flag nil ) (switch-flag) project-root-dir  )

    (setq project-root-dir (get-project-root-dir ".env") )
    (save-excursion
      (goto-char (point-min))
      (setq switch-flag  (search-forward-regexp "SWITCH-TO:" nil t  ) )
      ;; (message "switch-flag %s" switch-flag)
      (when switch-flag
        (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
        ;; (message "line-txt %s" line-txt)
        (when
            (or
             (string-match   "SWITCH-TO:.*\"\\([^ \t]*\\)\"[ \t]*"   line-txt)
             (string-match   "SWITCH-TO:[ \t]*\\([^ \t]*\\)[ \t]*"   line-txt)
             )
          (setq  opt-file (match-string  1 line-txt))
          ;; (message "KKKKKKKK %s=> %s" line-txt opt-file )
          (when (s-matches-p "^[a-z0-9]+$" opt-file  )
            (setq file-name (file-name-nondirectory (buffer-file-name)))
            (setq file-name-fix (file-name-base  file-name))
            (setq opt-file (concat "./" file-name-fix "." opt-file ) )
            ;;(message "2222 %s"  opt-file )

            )

          (unless (f-exists-p  opt-file )
            (setq opt-file ( get-route-jump-file-name (concat "/"  opt-file ) (get-url-path-get-fix-path-from-env "NEW_VUE_VIEW_DIR") ))
            )

          (unless (f-exists-p  opt-file )
            (setq opt-file ( get-route-jump-file-name (concat "/"  opt-file ) (get-url-path-get-fix-path-from-env "VUE_VIEW_DIR") ))
            )

          (unless (f-exists-p  opt-file )
            (setq opt-file ( get-route-jump-file-name (concat "/"  opt-file ) (get-url-path-get-fix-path-from-env "SWITCH_TO_CONFIG") ))
            )



          )))

    (if (and opt-file   (file-directory-p  opt-file) )
        (progn ;;目录
          (setq file-name (file-name-nondirectory (buffer-file-name)))
          (setq file-name-fix (file-name-base  file-name))

          (setq file-list (directory-files opt-file))
          (while (and file-list (not obj-file) )
            (setq check-file-name (car file-list) )
            (setq file-list (cdr file-list) )

            (if (and
                 (string= (file-name-base check-file-name ) file-name-fix  ) ;;
                 (not (string= file-name check-file-name   ));;后缀不一样
                 )
                (setq obj-file  (concat opt-file "/" check-file-name) ))))
      (setq obj-file opt-file))
    (unless obj-file
      (let ((path-name (buffer-file-name)) ctrl-name action-name tmp-arr  path-fix )
        (cond
         ((check-in-php-mode)
          (progn
            (setq ctrl-name (my-s-snake-case  (f-base  (f-base path-name ))) )
            (message "ctrl-name :%s" ctrl-name)
            (save-excursion
              (let (line-txt  )
                (ac-php--beginning-of-defun)
                (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                (setq tmp-arr (s-match  ".*function[ \t]+\\([a-zA-Z0-9_]*\\)"  line-txt ) )
                (when tmp-arr
                  (setq action-name (nth 1 tmp-arr) )
                  )))
            ;;phpcore tars
            (when (and (s-match "/app/Controllers/" path-name )  (not (string= action-name "__construct")) )
              (setq obj-file  (get-action-switch-to action-name ) )

              (unless  (and  obj-file (f-exists-p  obj-file ) )
                ;; (message "CHECK:%s=> %s"  (concat "/app/Controllers/(.*)/" (f-base path-name)) path-name )
                (setq tmp-arr (s-match (concat "/app/Controllers/\\(.*\\)/" (f-base path-name)) path-name ))
                (setq path-fix (concat "/" ctrl-name  "/" action-name ".vue"  ) )
                (when tmp-arr
                  (setq  path-fix (concat "/" (my-s-snake-case(nth 1 tmp-arr)) path-fix) ))

                (setq obj-file ( get-route-jump-file-name  path-fix (get-url-path-get-fix-path-from-env "NEW_VUE_VIEW_DIR") ))
                )

              (unless  (and  obj-file (f-exists-p  obj-file ) )
                (setq obj-file ( get-route-jump-file-name path-fix (get-url-path-get-fix-path-from-env "VUE_VIEW_DIR") ))
                )

              (message "========%s"  obj-file )
              )



            (unless (and  obj-file (f-exists-p  obj-file ) ) ;;to protobuf

              (setq tmp-arr (s-match (concat "/app/Controllers/\\(.*\\)/" (f-base path-name)) path-name ))
              (setq path-fix (concat "/" ctrl-name  "__" action-name ".proto"  ) )
              (when tmp-arr
                (setq  path-fix (concat "/" (my-s-snake-case(nth 1 tmp-arr)) path-fix) ))

              (setq obj-file (concat  project-root-dir "/proto/src/"  path-fix )  )
              (message "jump %s" obj-file)
              )

            ))
         ((string= major-mode  "go-mode")
          (let ( go-action-name )
            (setq ctrl-name   (my-s-snake-case (f-base  (f-base path-name ))) )
            (save-excursion
              (let (line-txt  )
                (beginning-of-defun)
                (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                (setq tmp-arr (s-match  ".*func[ \t]+([^)]+)[ \t]*\\([a-zA-Z0-9_]*\\)"  line-txt ) )
                (when tmp-arr
                  (setq go-action-name (nth 1 tmp-arr) )
                  (setq action-name (my-s-snake-case go-action-name ) )
                  )))
            (when (and (s-match "/controllers/" path-name )   )
              (let (view-dir)

                (setq obj-file  (get-action-switch-to go-action-name ) )
                (unless  (and  obj-file  (f-exists-p  obj-file ) )
                  (setq obj-file ( get-route-jump-file-name (concat "/" ctrl-name  "/" action-name ".vue"  ) (get-url-path-get-fix-path-from-env "NEW_VUE_VIEW_DIR") ))
                  )

                (unless  (and  obj-file  (f-exists-p  obj-file ) )
                  (setq obj-file ( get-route-jump-file-name (concat "/" ctrl-name  "/" action-name ".vue"  ) (get-url-path-get-fix-path-from-env "VUE_VIEW_DIR") ))
                  )

                )
              (unless (and  obj-file (f-exists-p  obj-file ) ) ;;to protobuf

                (setq obj-file (concat "../../proto/src/" ctrl-name "__" action-name ".proto" )  )
                )



              )))
         ;; node core ctrl ts
         ((and (check-file-ts  ) (s-match  "/controllers/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).ts"  path-name )  )
          (setq  tmp-arr  (switch-file-opt-node-ctrl project-root-dir  path-name ) )
          (setq  obj-file (nth 0 tmp-arr))
          (setq pos-info  (nth 1 tmp-arr))


          )
         ;; vue view ts
         ((check-file-ts  )
          (let (url file-info project-name)

            (setq tmp-arr (s-match  "/views/\\(\\([a-zA-Z0-9_-]*\\)/\\)?\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).ts"  path-name ) )
            (when tmp-arr
              (setq  ctrl-name   (nth 3 tmp-arr) )
              (setq  action-name   (nth 4 tmp-arr) )
              (setq  project-name (nth 2 tmp-arr) )
              (setq url (switch-file-opt-ts-url ) )
              (when (string=  url "")
                (setq url (concat "/" ctrl-name "/" action-name ) )
                (when project-name
                  (setq url (concat "/" project-name url ) )
                  )
                )
              )
            (ac-php--debug "path-name:%s=> %s" path-name  url )
            (when url
              (setq file-info  ( get-url-path-goto-info url ) )
              (setq  obj-file (nth 0 file-info) )
              (setq  pos-info (nth 1 file-info) )
              )
            (unless (and obj-file (f-exists? obj-file ) )
              (setq  obj-file  (concat "./" (file-name-base path-name ) ".vue" ) )
              (setq pos-info nil )
              )
            (unless (and obj-file (f-exists? obj-file ) )
              (setq  obj-file  (concat "./" (file-name-base path-name ) ".wxml" ) )
              (setq pos-info nil )
              )

            ))


         ( (or (string= major-mode  "web-mode" ) (string= major-mode  "vue-mode" )  )
           (setq tmp-arr (s-match  "/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).blade.php"  path-name ) )
           (when tmp-arr
             (setq  ctrl-name   (nth 1 tmp-arr) )
             (setq  action-name   (nth 2 tmp-arr) )

             (when (s-match "/views/" path-name )
               (setq  obj-file  (concat"../../../public/page_ts/" ctrl-name  "/" action-name ".ts" ) )

               )
             (let (js-obj-file)
               (when ( and (not (f-exists? obj-file )) (s-match "/views/" path-name )   )
                 (setq  js-obj-file  (concat"../../../public/page_js/" ctrl-name  "/" action-name ".js" ) )
                 (when (  f-exists? js-obj-file ) (setq obj-file js-obj-file)  )
                 )))
           ;;check vue .vue -> .ts
           (message "----%s" path-name)
           (setq tmp-arr (s-match  "/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\)\\.\\(vue\\|wxml\\)"  path-name ) )
           (when tmp-arr
             (setq  ctrl-name   (nth 1 tmp-arr) )
             (setq  action-name   (nth 2 tmp-arr) )
             (setq  obj-file  (concat"./" action-name ".ts" ) )
             )
           )


         ((string= major-mode  "protobuf-mode" )
          (let (url file-info path-fix project-name )
            (message "------------- %s " path-name)
            (setq tmp-arr (s-match  "/proto/src\\(/\\([^/]*\\)\\)?/\\([a-zA-Z0-9_-]*\\)__\\([a-zA-Z0-9_-]*\\).proto"  path-name ) )
            (when tmp-arr
              (setq  project-name (nth 2 tmp-arr) )
              (setq  ctrl-name   (my-s-upper-camel-case (nth 3 tmp-arr)) )
              (setq  action-name   (nth 4 tmp-arr) )
              (setq path-fix (concat "/" (my-s-upper-camel-case ctrl-name) ".php" ) )
              (when  project-name
                (setq path-fix (concat "/" (my-s-upper-camel-case project-name) path-fix ) )
                )

              (setq project-root-dir (get-project-root-dir ".env") )
              (setq  obj-file (concat project-root-dir "/src/app/Controllers"   path-fix ) )
              (setq pos-info ( concat "/function[ \t]*" action-name "[ \t]*(" ) )
              (unless (and obj-file (f-exists? obj-file ) )
                ;; check node-core
                (setq  obj-file (concat project-root-dir "/src/controllers/"  project-name "/" ctrl-name ".ts"  ) )
                (setq pos-info ( concat "/async[ \t]*" action-name "[ \t]*(" ) )
                )


              )
            ))
         )))

    (when obj-file
      (unless (f-exists? obj-file)
        (setq use-default  nil)
        (setq obj-file nil)
        )
      )

    (if obj-file
        (let(line-txt (move-flag t ))
          (find-file obj-file)
          (when pos-info
            (when (string=(substring-no-properties pos-info 0 1 )  "/")


              (when (> (line-number-at-pos )  2)
                (save-excursion
                  (if (check-file-ts    )
                      (re-search-backward "[ \t]*public[ \t]+" 0 t 1 )
                    ( evil-backward-section-begin)
                    )
                  (setq line-txt (buffer-substring-no-properties
                                  (line-beginning-position)
                                  (line-end-position )))
                  (when (s-matches-p (substring-no-properties pos-info 1 ) line-txt  ) ;;同一个区域
                    (setq move-flag nil ))
                  ))
              (when move-flag
                (goto-char (point-min))
                (re-search-forward  (substring-no-properties pos-info 1 ) )
                (forward-line))
              )
            ))

      )))

;;XXX




(defun trim-string (string)
  "STRING."
  (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string))
  )


;;

;;------------------------------------------------------------


(defun fcitx-inactivate-input-method()
  "Fcitx 关闭输入法."
  (interactive)
  (when (check-in-linux)
    (call-process  fcitx-remote nil 0 nil  "-c") )
  (when (check-in-mac)
    (call-process  "im-select" nil 0 nil  "com.apple.keylayout.ABC") )
  )

(defun fcitx-activate-input-method()
  "Fcitx 开启输入法."
  (interactive)

  (when (check-in-linux)
    (call-process  fcitx-remote nil 0 nil  "-o"))
  ;;(when (check-in-mac)
  ;;  (call-process  "input_switch" nil 0 nil  "-s" "搜狗拼音") )

  )



;;全屏
(defun my-fullscreen ()
  "D."
  (interactive)
  (when (check-in-linux)
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     '(2 "_NET_WM_STATE_FULLSCREEN" 0)) )
  )
(defun my-delete-other-windows ()
  "D."
  (interactive )
  (delete-other-windows)
  (delete-window (treemacs-get-local-window))
  )

;;最化大
(defun my-maximized ()
  "D."
  (interactive)
  (when (check-in-linux )
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)) )
  )
;;(progn (skip-syntax-backward "w_") (point))

(defun get-whole-word-pos (&optional arg)
  "得到当前单词的开始和结束 ARG."
  (save-excursion
    (let ((beg
           (progn (skip-syntax-backward "w_") (point)))
          (end
           (progn (skip-syntax-forward "w_") (point))
           ))
      (list beg end))))
(defun copy-whole-word (&optional arg)
  "ARG."
  (interactive)
  (let ( pos )
    (setq pos (get-whole-word-pos))
    (copy-region-as-kill (car pos) (cadr pos))
    ))



(defun xcwen-beautify-json ()
  "D."
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
                             "python -c 'import sys,json; data=json.loads(sys.stdin.read()); print json.dumps(data,sort_keys=True,indent=4).decode(\"unicode_escape\").encode(\"utf8\",\"replace\")'"
                             (current-buffer) t)))

;;删除当前单词
(defun kill-whole-word (&optional arg)
  "ARG."
  (interactive)
  (let (pos)
    (setq pos (get-whole-word-pos))
    (kill-region (car pos) (cadr pos))))
(defun upper-or-lower-whole-word (count &optional arg)
  "COUNT, ARG."
  (interactive "p")
  (let (pos cur_char word next_word (cur-point (point) ) )
    (message "xxxxxxxx %d" count)


    (setq pos (get-whole-word-pos))
    (setq word  (s-trim (buffer-substring-no-properties  (car pos) (cadr pos) ) ) )

    (when (>  (length word  ) 1)

      (if (= count 1)

          (if (s-match "_" ( my-s-snake-case word) )
              (progn

                (cond
                 ((s-uppercase?  word ) ;;ONE_TWO => one_two
                  (setq next_word (s-downcase word))
                  )
                 (  (string=  word (my-s-snake-case word)  )   ;;one_two => OneTwo

                    (setq next_word (my-s-upper-camel-case word))

                    )
                 ((string=  word (my-s-upper-camel-case word) ) ;; OneTwo => oneTwo
                  (setq next_word (my-s-lower-camel-case  word ) )
                  )

                 ((string=  word (my-s-lower-camel-case word) )  ;; oneTwo => ONE_TWO
                  (setq next_word (s-upcase (my-s-snake-case word)) )
                  )
                 (t
                  (setq next_word (s-upcase (my-s-snake-case word)) )
                  )))
            (cond
             ((s-uppercase?  word ) ;;ONE => one
              (setq next_word (s-downcase word))
              )
             (  (string=  word ( my-s-snake-case word)  )   ;;one=> One

                (setq next_word (my-s-upper-camel-case word))

                )
             ((string=  word (my-s-upper-camel-case word) ) ;; One=> ONE
              (setq next_word (s-upcase (my-s-snake-case word)) )
              )
             (t
              (setq next_word (s-upcase (my-s-snake-case word)) )
              )))
        (progn ;;
          (setq  word (s-upcase (my-s-snake-case word)) )
          (cond
           ((= count  2) ;;  one_two
            (setq next_word  (my-s-snake-case word) )
            )
           ((= count  3) ;;  oneTwo
            (setq next_word (my-s-lower-camel-case  word ) )
            )
           ((= count  4) ;;  oneTwo
            (setq next_word (my-s-upper-camel-case  word ) )
            )
           ((= count  5) ;;  ONE_TWO
            (setq next_word (s-upcase  word) )
            )
           )

          )


        )
      (save-excursion
        (kill-region  (car pos) (cadr pos) )
        (insert next_word ))

      (goto-char cur-point)

      )

    ))
;;---------------------------------------------------------------------------







(defun match-paren (arg)
  "Go ARG to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
;;---------------------------------------------------------------------------

(defun join-line-0 (arg)
  "ARG."
  (interactive "p")
  (join-line 0))

(defun json2php (arg)
  "D ARG."
  (interactive "p")
  (let (txt)
    (setq txt (buffer-substring-no-properties (region-beginning)(region-end)) )

    (setq txt (s-replace "}" "]" txt  ))
    (setq txt (s-replace "{" "[" txt  ))
    (setq txt (s-replace ":" "=>" txt  ))
    (kill-new  txt)
    )
  )

(defun comment-or-uncomment-whole-line(num)
  "NUM."
  (save-excursion
    (beginning-of-line)
    (let ((begin-point (point)))
      (forward-line num)
      (comment-or-uncomment-region   begin-point (point)))
    ))

(defun copy-whole-line(num)
  "NUM."
  (save-excursion
    (beginning-of-line)
    (let ((begin-point (point)))
      (forward-line num)
      (copy-region-as-kill begin-point (point)))
    ))

(defun get-mark-pos-ex ()
  "D."
  (let( reg-begin-pos start-pos reg-end-pos end-pos  )
    "跨行，则得到所有行的开始和结束."
    (setq reg-begin-pos (region-beginning))
    (setq reg-end-pos (region-end))
    (forward-char (- reg-begin-pos (point) ))
    (beginning-of-line)
    (setq  start-pos  (point))
    (forward-char (- reg-end-pos (point) ))  ;;------
    (if (= (current-column) 0 )
        (backward-char 1 ))
    (end-of-line)
    (setq  end-pos  (if (= (point) (point-max) ) (point-max) (+ (point) 1 ) ))
    (list start-pos end-pos )))

(defun mark-region-ex(&optional arg)
  "ARG."
  (interactive "P")
  (let ( tmp-mark-pos)
    (setq tmp-mark-pos  (get-mark-pos-ex))
    (forward-char (- (car tmp-mark-pos) (point) ))
    (push-mark (cadr tmp-mark-pos) nil t )))



;;功能
;;
(defun opt-region-or-whole-line(opt-type   arg)
  "提供高级的复制 剪切功能 OPT-TYPE ARG."
  (let ( do-region-func do-line-func  tmp-mark-pos )
    (save-excursion
      (cond
       ( (string= opt-type "copy")
         (setq do-region-func 'copy-region-as-kill do-line-func  'copy-whole-line  ))

       ( (string= opt-type "comment")
         (setq do-region-func 'comment-or-uncomment-region do-line-func   'comment-or-uncomment-whole-line ))
       (t
        (setq do-region-func 'kill-region do-line-func  'kill-whole-line  )))

      (if (and  mark-active
                (not  (= (region-beginning) (region-end) ))
                )
          (if (string-match "\n"
                            (buffer-substring-no-properties (region-beginning)(region-end)))
              (progn

                (setq tmp-mark-pos  (get-mark-pos-ex))
                (funcall do-region-func (car tmp-mark-pos) (cadr tmp-mark-pos)  )
                ) ;-----------
            (funcall do-region-func (region-beginning) (region-end) ))
        (progn
          (or arg (setq arg 1))
          (message "%s line :%d"  opt-type arg)
          (funcall do-line-func arg))))))

;;;###autoload
(defun copy-region-or-whole-line(&optional arg)
  "ARG.
有选择区域时.
1:复制的内容是跨行的：复制区域所在的所有行的内容。不仅仅是区域内的内容
2:复制的内容没有跨行：复制区域中的内内容
没有选择区域时:
1:复制所在的行
2:支持复制多行.  如 复制3行是  `M-3' `C-w'."
  (interactive "P")


  (opt-region-or-whole-line "copy" arg)
  )



;;;###autoload
(defun copy-field-list(&optional arg)
  "ARG.
有选择区域时：
1:复制的内容是跨行的：复制区域所在的所有行的内容。不仅仅是区域内的内容
2:复制的内容没有跨行：复制区域中的内内容
没有选择区域时:
  1:复制所在的行
  2:支持复制多行.  如 复制3行是  `M-3' `C-w'."
  (interactive "P")

  (let ( tmp-mark-pos  txt line-list match_arr field_name ret-str  field_name_list )

    (or arg (setq arg 1))
    (setq tmp-mark-pos  (get-mark-pos-ex))
    (setq txt (buffer-substring-no-properties (car tmp-mark-pos) (cadr tmp-mark-pos)) )
    (setq line-list (s-split "\n" txt))
    (setq ret-str "")
    (cond
     ((s-match "^[ \t]+`[a-z0-9_A-Z]+`"  txt )
      (message "KKKKK")
      (cl-dolist  (line  line-list)

        (setq match_arr  ( s-match "^[ \t]+`\\([a-z0-9_A-Z]+\\)`"  line ))
        (setq field_name (nth 1 match_arr )  )
        (when field_name (setq field_name_list (append   field_name_list (list field_name ) )))
        ))

     ((s-match "^[ \t]+\\$[a-z0-9_A-Z]+"  txt )
      (cl-dolist  (line  line-list)
        (setq match_arr  ( s-match "^[ \t]+\\$\\([a-z0-9_A-Z]+\\)"  line ))
        (setq field_name (nth 1 match_arr )  )
        (when field_name (setq field_name_list (append   field_name_list (list field_name ) )))
        ))
     )
    (message "==== %S" field_name_list)

    (cl-dolist  (field_name field_name_list   )
      (cond
       (( = arg 2 ) (setq  ret-str  (concat ret-str "\n" "$"  field_name "= $row[\"" field_name "\"];"     ) ))
       (( = arg 3 ) (setq  ret-str  (concat ret-str "\n"  "\"" field_name "\"=> $row[\"" field_name "\"],"     ) ))
       (( = arg 4 ) (setq  ret-str  (concat ret-str    field_name "\n"   ) ))
       (t (setq  ret-str  (concat ret-str "\n" "\"" field_name "\"=> $"  field_name ","   ) ) ))
      )

    (kill-new  ret-str)
    )
  )

;;;###autoload
(defun comment-or-uncomment-region-or-whole-line(&optional arg)
  "ARG.
有选择区域时：
  1:comment的内容是跨行的：comment区域所在的所有行的内容。不仅仅是区域内的内容
  2:comment的内容没有跨行：comment区域中的内内容
没有选择区域时:
  1:comment所在的行
  2:支持comment多行.  如 comment3行是  `M-3' `C-w'."
  (interactive "P")
  (opt-region-or-whole-line "comment" arg)
  )


;;;###autoload
(defun kill-region-or-whole-line(&optional arg)
  "ARG.
有选择区域时：
  1:剪切的内容是跨行的：剪切区域所在的所有行的内容。不仅仅是区域内的内容
  2:剪切的内容没有跨行：剪切区域中的内内容
没有选择区域时:
  1:剪切所在的行
  2:支持剪切多行.  如 剪切3行是  `M-3' `C-k'."
  (interactive "P")
  (opt-region-or-whole-line "kill" arg))







;;------------------------------------------------------------

(defun begin-line-and-insert-line ( arg)
  "ARG."
  (interactive "P")
  (move-beginning-of-line 1)
  (open-line 1))

;;
(defun  region-indent-ex ( is-add )
  "整体缩进 IS-ADD."
  (interactive)
  (let( mark-pos  is-add)
    (save-excursion
      (setq mark-pos  (get-mark-pos-ex))
      (message  "%d %d" (car mark-pos) (cadr mark-pos) )
      (if is-add
          (replace-match "^" "    " nil (nth 0 mark-pos) (- (nth 1 mark-pos) 1) )
        (replace-match "\\(^\t\\)\\|\\(^    \\)" "" nil (nth 0 mark-pos) (- (nth 1 mark-pos)  1)))
      )))
(defun region-indent-add ()
  "DOCSTRING."
  (interactive)
  (region-indent-ex t)
  )
(defun region-indent-sub ()
  "DOCSTRING."
  (interactive)
  (region-indent-ex nil)
  )
(defun get-string-from-file (file-path)
  "Return filePath's file content FILE-PATH."
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))





(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun backward-kill-word-without-_ ()
  "DOCSTRING."
  (interactive)
  (if (and  mark-active
            (not  (= (region-beginning) (region-end) ))
            )
      (kill-region (region-beginning) (region-end) )
    (progn
      (let (start-pos end-pos)
        (setq start-pos (point))
        (save-excursion
          (skip-chars-backward "^a-z0-9A-Z一-龠^")
          (skip-chars-backward "a-z0-9一-龠^")
          (skip-chars-backward "A-Z")
          (setq end-pos (point))
          )
        (kill-region start-pos end-pos)))))



(defun switch-file-term ()
  "交换终端和文件."
  (interactive)
  ;;(message "%s %s %s" "====" opt-file-name "kkk")
  (if (string= major-mode  "vterm-mode")
      (evil-buffer nil )
    (multi-vterm-goto-last-vterm)
    ))



(defun get-cur-pkg()
  "D."
  (save-excursion
    (let ( start-pos ( end-pos (point) ) tmp-arr txt)
      (backward-word)
      (setq start-pos (point) )
      (setq txt (buffer-substring-no-properties start-pos end-pos ) )
      (message "=======[%s]" txt)

      (setq tmp-arr (s-match  "\\([a-zA-Z0-9_]+\\)" txt) )

      (when tmp-arr
        (nth 1 tmp-arr)
        )
      )))


(defun yas-expand-for-vim(&optional field)
  "Expand a snippet before point.

If no snippet expansion is possible, fall back to the behaviour
defined in `yas-fallback-behavior'.

Optional argument FIELD is for non-interactive use and is an
object satisfying `yas--field-p' to restrict the expansion to."
  (interactive)
  (setq yas--condition-cache-timestamp (current-time))
  (let (templates-and-pos)
    (unless (and yas-expand-only-for-last-commands
                 (not (member last-command yas-expand-only-for-last-commands)))
      (setq templates-and-pos (if field
                                  (save-restriction
                                    (narrow-to-region (yas--field-start field)
                                                      (yas--field-end field))
                                    (yas--templates-for-key-at-point))
                                (yas--templates-for-key-at-point))))
    (if templates-and-pos
        (yas--expand-or-prompt-for-template (cl-first templates-and-pos)
                                            (cl-second templates-and-pos)
                                            (cl-third templates-and-pos))
      (progn
        (let ((c (char-before)))
          (cond
           ((and (or  (string= major-mode "c-mode") (string= major-mode "c++-mode"))
                 (or (eq ?\. c)
                     ;; ->
                     (and (eq ?> c)
                          (eq ?- (char-before (1- (point)))))
                     ;; ::
                     (and (eq ?: c)
                          (eq ?: (char-before (1- (point)))))))
            (company-complete))

           ((and (check-in-php-mode)
                 (or
                  ;; ->
                  (and (eq ?> c)
                       (eq ?- (char-before (1- (point)))))
                  ;;\
                  (eq ?\\ c)
                  ;; ::
                  (and (eq ?: c)
                       (eq ?: (char-before (1- (point)))))))

            (message "do ac-source-php")
            (company-complete  ))


           ((and (string= major-mode "go-mode")  (eq ?\. c))
            ( company-complete )
            )

           ((and (string= major-mode "java-mode")  (eq ?\. c))
            (company-complete  ) )
           ((and
             (or (string= major-mode "rust-mode")
                 (string= major-mode "rustic-mode")
                 )
             (or
              ;; .
              (eq ?\. c)
              ;; ::
              (and (eq ?: c)
                   (eq ?: (char-before (1- (point)))))))

            (company-complete  ))


           ((and (string= major-mode "lua-mode")  (eq ?\. c))
            (company-complete  ) )
           ((and (string= major-mode "python-mode")  (eq ?\. c))
            (company-complete  ) )
           ;; ((and (string= major-mode "erlang-mode")  (eq ?\: c))
           ;;  ( auto-complete  ))
           ((and (string= major-mode "typescript-mode")  (eq ?\. c))
            ( company-complete ))
           ((and (string= major-mode "vue-mode")  (eq ?\. c))
            ( company-complete ))

           ((and (string= major-mode "dart-mode")  (eq ?\. c))
            ( company-complete ))
           ((and (string= major-mode "elixir-mode")  (eq ?\. c))
            ( company-complete ))
           ((and (string= major-mode "term-mode")  )
            (  term-send-raw-string "\t" ))

           ((and (string= major-mode "org-mode")  )
            ( org-cycle ))
           ( t (indent-for-tab-command ))))
        )
      )))




(defun my-show-table-info()
  "Doc."
  (interactive)
  (let ((cur-word (ac-php--get-cur-word)) cmd)
    ;;(setq  cmd (concat "desc   "  cur-word  ";\n show create table " cur-word ";" ) )
    (setq  cmd (concat "desc   "  cur-word  ";" ) )
    (message "==%s" cmd)
    (lsp-sql-execute-query cmd)
    ))

(defun yas-reset ()
  "Doc."
  (interactive)
  (let ()
    (yas-recompile-all)
    (yas-reload-all)
    ))
(defadvice find-function (before jim-find-funtion  activate compile)
  "D."
  (interactive (find-function-read))
  (xref-push-marker-stack )
  )


(defun my-set-evil-local-map( key fun  )
  "KEY, FUN."
  (define-key evil-normal-state-local-map (kbd key ) fun)
  (define-key evil-insert-state-local-map (kbd key ) fun)
  (define-key evil-motion-state-local-map (kbd  key) fun)
  )


(defun my-set-evil-not-insert-local-map( key fun  )
  "KEY, FUN."
  (define-key evil-normal-state-local-map (kbd key ) fun)
  (define-key evil-motion-state-local-map (kbd  key) fun)
  )

(defun my-set-evil-main-local-map( key fun  )
  "KEY, FUN."
  (my-set-evil-not-insert-local-map (concat  "," key ) fun )
  )

(defun my-jump-set-evil-local-map( jump-fun  &optional back-fun   )
  "JUMP-FUN BACK-FUN."

  (define-key evil-normal-state-local-map (kbd "C-]")  jump-fun)
  (define-key evil-insert-state-local-map (kbd "C-]") jump-fun)
  (define-key evil-motion-state-local-map (kbd "C-]") jump-fun)

  (when back-fun
    (define-key evil-normal-state-local-map (kbd "C-t")  back-fun)
    (define-key evil-insert-state-local-map (kbd "C-t") back-fun)
    (define-key evil-motion-state-local-map (kbd "C-t") back-fun)
    )

  )
(defun core-server--get-project-root-dir ()
  "Get the project root directory of the curent opened buffer."
  ;;(ac-php--debug "Lookup for the project root...")
  (let (project-root-dir tags-file (file-name buffer-file-name))

    ;; 1. Get working directory using `buffer-file-name' or `default-directory'
    (if file-name
        (setq project-root-dir (file-name-directory file-name))
      (setq project-root-dir (expand-file-name default-directory)))

    ;; 3. Scan for the real project root of the opend file
    ;; We're looking either for the `ac-php-config-file' file
    ;; or the '.projectile' file, or the 'vendor/autoload.php' file
    (let (last-dir)
      (while
          (not (or
                (file-exists-p (concat project-root-dir "tars/tars.proto.php"))
                (string= project-root-dir "/")))
        (setq last-dir project-root-dir
              project-root-dir (file-name-directory
                                (directory-file-name project-root-dir)))
        (when (string= last-dir project-root-dir)
          (setq project-root-dir "/"))))

    (when (string= project-root-dir "/")
      (progn
        (message "core-server : Unable to resolve project root")
        (setq project-root-dir nil)))

    project-root-dir))
(defun get-project-root-dir (find-file-name)
  "Get the project root directory of the curent opened buffer FIND-FILE-NAME."
  ;;(ac-php--debug "Lookup for the project root...")
  (let (project-root-dir tags-file (file-name buffer-file-name))

    ;; 1. Get working directory using `buffer-file-name' or `default-directory'
    (if file-name
        (setq project-root-dir (file-name-directory file-name))
      (setq project-root-dir (expand-file-name default-directory)))

    ;; 3. Scan for the real project root of the opend file
    ;; We're looking either for the `ac-php-config-file' file
    ;; or the '.projectile' file, or the 'vendor/autoload.php' file
    (let (last-dir)
      (while
          (not (or
                (file-exists-p (concat project-root-dir find-file-name ))
                (string= project-root-dir "/")))
        (setq last-dir project-root-dir
              project-root-dir (file-name-directory
                                (directory-file-name project-root-dir)))
        (when (string= last-dir project-root-dir)
          (setq project-root-dir "/"))))

    (when (string= project-root-dir "/")
      (progn
        (setq project-root-dir nil)))

    project-root-dir))


(defun go-core-server--get-project-root-dir ()
  "Get the project root directory of the curent opened buffer."
  ;;(ac-php--debug "Lookup for the project root...")
  (let (project-root-dir tags-file (file-name buffer-file-name))

    ;; 1. Get working directory using `buffer-file-name' or `default-directory'
    (if file-name
        (setq project-root-dir (file-name-directory file-name))
      (setq project-root-dir (expand-file-name default-directory)))

    ;; 3. Scan for the real project root of the opend file
    ;; We're looking either for the `ac-php-config-file' file
    ;; or the '.projectile' file, or the 'vendor/autoload.php' file
    (let (last-dir)
      (while
          (not (or
                (file-exists-p (concat project-root-dir ".env"))
                (string= project-root-dir "/")))
        (setq last-dir project-root-dir
              project-root-dir (file-name-directory
                                (directory-file-name project-root-dir)))
        (when (string= last-dir project-root-dir)
          (setq project-root-dir "/"))))

    (when (string= project-root-dir "/")
      (progn
        (message "core-server : Unable to resolve project root")
        (setq project-root-dir nil)))

    ;;(ac-php--debug "Lookup for the project root:[%s]"  project-root-dir    )
    project-root-dir))




(defun core-server-make()
  "DOCSTRING."
  (interactive)
  (let ((project-dir (core-server--get-project-root-dir )) )
    (message "====%s" project-dir)
    (when project-dir
      (message "%s" (shell-command-to-string (concat project-dir "/proto/gen_proto.sh" )  )))))

(defun go-core-server-make()
  "DOCSTRING."
  (interactive)
  (let ((project-dir (go-core-server--get-project-root-dir )  )  cmd)

    (setq cmd (concat project-dir "/restart.sh " ) )
    (message "cmd:%s"  cmd)
    (when project-dir
      (message "%s" (shell-command-to-string cmd  )))))

(defun restart-project()
  "DOCSTRING."
  (interactive)
  (let ((project-dir (go-core-server--get-project-root-dir )  )  cmd)

    (setq cmd ( concat "cd  " project-dir "&& ./restart.sh " ) )
    (message "cmd:%s"  cmd)
    (when project-dir
      (message "%s" (shell-command-to-string cmd  )))))



(defun my-join-line ()
  "DOCSTRING."
  (interactive)
  (let (var1 pos-start pos-end buf)
    (setq pos-start (region-beginning)   )
    (setq pos-end   (region-end) )
    (copy-region-as-kill pos-start pos-end )
    (setq buf (nth 0 kill-ring))

    (setq buf (s-replace  "\n" "" buf ) )
    (kill-new buf )
    ))



(defun my-goto-file ()
  "DOCSTRING."
  (interactive)
  (let (line-txt  line-info filename  line deal-flag file-info)
    (setq line-txt (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position )))

    (setq line-info  (split-string  line-txt ":" ) )
    (when (=  (length  line-info ) 2)
      (setq filename  (nth 0 line-info) )
      (setq line (string-to-number  (nth 1 line-info)) )
      (when (file-exists-p  filename  )
        (find-file filename)
        (goto-char (point-min))
        (forward-line (1-  line ))
        (setq deal-flag t )))

    (when (string= "js2-mode" major-mode)
      (setq file-info (js-get-file-at-point) ))

    (if (check-file-ts )
        (progn
          (setq file-info (ts-get-file-at-point) )
          (message "file-info %S" file-info ))
      (when (or (string= "web-mode" major-mode)  (string= "vue-mode" major-mode))
        (setq file-info (web-get-file-at-point) ))

      )




    (when  ( and (nth 0 file-info) (file-exists-p  (nth 0 file-info)  ) )
      (find-file  (nth 0 file-info)  )
      ;;pos info
      (let ((pos-info (nth 1 file-info)) )
        (when pos-info
          (when (string=(substring-no-properties pos-info 0 1 )  "/")
            (goto-char (point-min))
            (re-search-forward  (substring-no-properties pos-info 1 ) )
            )
          ))
      (setq deal-flag t ))

    (unless deal-flag (find-file-at-point))))



(defadvice edts-find-source-under-point (before  jim-edts-find-source-under-point activate compile)
  "D."
  (interactive)
  (message "xxxx  edts-find-source-under-point ")
  (xref-push-marker-stack )
  )

(defun java-gen-get-set-code()
  "DOCSTRING."
  (interactive)
  (let (
        line-txt
        value
        (cur-word (ac-php--get-cur-word))
        (class-name "<...>" )
        )
    (setq line-txt (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position )))
    (string-match (concat "\\(\\(public\\)\\|\\(private\\)\\)[ \t]*\\([a-zA-Z].+\\)[ \t]+\\b" cur-word  "\\b"  ) line-txt)
    (setq class-name  (match-string-no-properties 4 line-txt) )
    (setq value (my-s-upper-camel-case  cur-word) )
    (kill-new (concat
               "\n\t/**\n\t*/\n\tpublic "class-name " get" value "(){\n\n\t\treturn this."  cur-word ";\n\t}\n"
               "\n\t/**\n\t*/\n\tpublic void set" value "(" class-name " value ){\n\n\t\tthis."cur-word"=value;\n\t}\n"
               ) )
    ))


;; flutter-monitor 监控
(defun flutter-monitor( &optional arg)
  "Doc ARG ."
  (interactive "P")
  (let (cur-frame-count)
    (when  (and arg ( =  arg 1) )
      (kill-buffer "*Flutter*" )
      )

    (setq cur-frame-count  (length ( frame-list)) )
    (switch-to-buffer-other-frame  "*Flutter*" )
    (delete-other-windows)

    ;;新开的窗口
    (if (= cur-frame-count 1)
        (progn
          (set-frame-size (selected-frame) 45 60)
          (set-frame-position (selected-frame) 0 0)
          ))


    (if (flutter--running-p)
        (if (and arg ( =  arg 2) )
            (flutter-hot-restart)
          (flutter-hot-reload))

      (flutter-run "-d  emulator-5554 " ))


    ;; 光标移到最后
    (goto-char (point-max))


    ;;回到主窗口
    (select-frame-set-input-focus (next-frame))

    ))

(defvar my-backup-directory "~/my-backups/")
(defvar my-max-backups 10)

(defun my-save-backup ()
  "Save a backup of the current file to the backup directory with timestamp."
  (when buffer-file-name
    (let* ((current-time-string (format-time-string "%Y%m%d%H%M%S"))
           (backup-file (expand-file-name (concat (file-name-nondirectory buffer-file-name) "-" current-time-string) my-backup-directory)))
      (unless (file-exists-p my-backup-directory)
        (make-directory my-backup-directory t))
      (copy-file buffer-file-name backup-file t t)
      (message "Backup saved to: %s" backup-file)
      (my-trim-backups))))

(defun my-trim-backups ()
  "Delete excess backups and keep only the most recent ones."
  (let (
        (sorted-backup-files (sort (directory-files my-backup-directory t "[^.].*" t)
                                   (lambda (a b)
                                     (not (time-less-p (nth 5 (file-attributes a))
                                                       (nth 5 (file-attributes b)))))))
        )
    (when (> (length sorted-backup-files) my-max-backups)
      (dolist (file (nthcdr my-max-backups  sorted-backup-files))
        (delete-file file)
        (message "Deleted old backup: %s" file)))))


(add-hook 'before-save-hook 'my-save-backup)


(defun format-xml-with-xmlstarlet ()
  "Format the current XML buffer using xmlstarlet and replace the buffer content."
  (interactive)
  (let ((xml-content (buffer-string) )  pos-start  formatted-xml ret )  ;; 获取当前 buffer 的内容
    (with-temp-buffer
      ;; 使用 xmlstarlet 格式化 XML 内容
      (insert xml-content)
      (setq pos-start (point-max))
      (setq ret (call-process-region (point-min) (point-max) "xmlstarlet" t t nil "fo"))
      (if (eq ret 0 )
          (setq formatted-xml (buffer-substring-no-properties (point-min) (point-max) ))
        (message "出错\n:%s" (buffer-substring-no-properties (point-min) (point-max) ) )
        ))
    ;; 用格式化后的内容替换当前 buffer
    ( when formatted-xml
      (erase-buffer)
      (insert formatted-xml)
      )
    ))

;;sudo yarn global add sql-formatter
(defun format-sql-with-sql-formatter ()
  "Format the current sql buffer .
 using  sql-formatter and replace the buffer content."
  (interactive)
  (let ((sql-content (buffer-string) )  pos-start  formatted-sql ret )  ;; 获取当前 buffer 的内容
    (with-temp-buffer
      ;; 使用 格式化 SQL 内容
      (insert sql-content)
      (setq pos-start (point-max))
      (setq ret (call-process-region (point-min) (point-max) "sql-formatter" t t nil "-l" "mysql" ))
      (if (eq ret 0 )
          (setq formatted-sql (buffer-substring-no-properties (point-min) (point-max) ))
        (message "出错\n:%s" (buffer-substring-no-properties (point-min) (point-max) ) )
        ))
    ;; 用格式化后的内容替换当前 buffer
    ( when formatted-sql
      (erase-buffer)
      (insert formatted-sql)
      )
    ))

(defun format-sql-region-with-sql-formatter (start end)
  "使用 sql-formatter 格式化选中的 SQL 区域并替换."
  (interactive "r")
  (let ((sql-content (buffer-substring-no-properties start end))
        formatted-sql ret)
    (with-temp-buffer
      (insert sql-content)
      (setq ret (call-process-region (point-min) (point-max) "sql-formatter" t t nil "-l" "mysql"))
      (if (eq ret 0)
          (setq formatted-sql (buffer-substring-no-properties (point-min) (point-max)))
        (message "格式化出错:\n%s"
                 (buffer-substring-no-properties (point-min) (point-max)))))
    (when formatted-sql
      (delete-region start end)
      (goto-char start)
      (insert formatted-sql))))


(defun insert-line-begin-space ()
  "在选中区域每行前插入4个空格，处理后保留选区."
  (interactive)
  (let* ((start (region-beginning))
         (end (region-end))
         (insert-str "    ")
         (deactivate-mark nil))  ;; 保持选区
    (save-excursion
      (goto-char start)
      (let ((end-marker (copy-marker end)))
        (while (< (point) end-marker)
          (beginning-of-line)
          (insert insert-str)
          ;; 每次插入会改变区域结束位置，因此需要更新 marker
          (setq end-marker (+ end-marker (length insert-str)))
          (forward-line 1))))))
(defun remove-line-begin-space ()
  "在选中区域每行前移除4个空格或一个TAB，处理后保留选区."
  (interactive)
  (let* ((start (region-beginning))
         (end (region-end))
         (deactivate-mark nil))  ;; 保持选区
    (save-excursion
      (goto-char start)
      (let ((end-marker (copy-marker end)))
        (while (< (point) end-marker)
          (beginning-of-line)
          (cond
           ((looking-at "^\t")
            (delete-char 1))
           ((looking-at "^    ")
            (delete-char 4)))
          (forward-line 1))))))


(defun my/toggle-sql-editor-smart ()
  "根据当前窗口尺寸自动选择在右侧或下方显示 term.sql（/Users/jim/bin/term.sql）。
如果已经显示则关闭；如果在下方显示，则设置高度为6行。"
  (interactive)
  (let* ((file-path "/Users/jim/bin/term.sql")
         (buffer (or (find-buffer-visiting file-path)
                     (find-file-noselect file-path)))
         (sql-window (get-buffer-window buffer))
         (current-window (selected-window))
         (win-height (window-total-height current-window))
         (win-width  (window-total-width current-window))
         (split-direction (if (> win-width (* win-height 3 )) 'right 'below))
         (target-window (window-in-direction split-direction)))


    (if (and sql-window
             (window-live-p sql-window)
             )
        ;; 已经在对应方向显示 term.sql → 关闭窗口
        (delete-window sql-window)

      ;; 否则打开并切换
      (progn
        (if (and target-window (window-live-p target-window))
            (select-window target-window)
          (if (eq split-direction 'right)
              (split-window-right)
            (split-window-below))
          (other-window 1))

        ;; 切换并设置 sql-mode
        (switch-to-buffer buffer)
        (sql-mode)

        ;; 如果是向下打开 → 调整窗口高度为6行
        (when (eq split-direction 'below)
          (let ((target-height 12)
                (current-height (window-total-height)))
            (when (/= current-height target-height)
              (window-resize nil (- target-height current-height) nil)))) ; 垂直方向

        (message "已在%s方打开 term.sql %d %d"
                 (if (eq split-direction 'right) "右" "下") win-width win-height ) ))))




(defun my/send-sql-to-current-vterm ()
  "将选中区域或当前行发送到当前可见的 vterm buffer，并进行内容校验。"
  (interactive)
  (let* ((text (if (use-region-p)
                   (buffer-substring-no-properties (region-beginning) (region-end))
                 (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
         (clean-text (replace-regexp-in-string "--.*$" "" text))  ;; 去掉注释
         (stripped (string-trim clean-text))
         (vterm-win (seq-find
                     (lambda (win)
                       (with-current-buffer (window-buffer win)
                         (derived-mode-p 'vterm-mode)))
                     (window-list))))

    (cond
     ;; 无有效 SQL
     ((or (not stripped)
          (string= stripped "")
          (string-match-p "^;+\\s-*$" stripped))
      (message "未检测到有效 SQL 内容，取消发送。"))

     ;; 没有可见的 vterm
     ((not vterm-win)
      (message "当前没有可见的 vterm buffer，取消发送。"))

     ;; 正常发送
     (t
      (with-current-buffer (window-buffer vterm-win)
        (goto-char (point-max))
        (vterm-send-string text)
        (vterm-send-return))
      (message "SQL 已发送到当前可见 vterm")))))

(provide 'xcwen-misc)


;;; xcwen-misc.el ends here
