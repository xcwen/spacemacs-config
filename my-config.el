;;; my-config.el --- Some basic utility function of xcwen
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


;;; Code:
(require 'core-dotspacemacs)
(add-to-list 'load-path   dotspacemacs-directory  )
(load  (expand-file-name "xcwen-misc.el" dotspacemacs-directory) )
(require 'xcwen-misc)
(load  (expand-file-name "init-syntax-table.el" dotspacemacs-directory) )
;; (load  (expand-file-name "php-doc-block.el" dotspacemacs-directory) )
(require'core-jump)

(require 'php-ts-mode)
(require 'lsp-ui-doc)
(require 'lsp-ui)
(require 'lsp)
                                        ;(require 'undo-tree)
(require 'evil-org)
(require 'info+)
(require 'evil-commands)
(require 'evil-matchit)
(require 'evil-states)
(require 'eterm-256color)
(require 'helm-projectile)
;; (require 'ccls)
(setq my-keyboard-input-dev "/dev/input/event7")


(spacemacs|define-jump-handlers php-ts-mode)
(add-to-list 'spacemacs-jump-handlers-php-ts-mode 'ac-php-find-symbol-at-point)

(defun set-main-key()
  "D."

  (define-key evil-motion-state-map "," nil )

  (set-evil-main-state-key "w" 'save-buffer )

  (set-evil-main-state-key "u" 'upper-or-lower-whole-word)
  (set-evil-main-state-key "L" 'revert-buffer )
  (set-evil-main-state-key "a" 'switch-file-opt )
  (set-evil-main-state-key "A" 'switch-file-opt-proto )
  (set-evil-main-state-key "e" 'cleanup-and-goto-error)
  ;;(set-evil-main-state-key "d" 'show-baidu-dict-at-region)
  (set-evil-main-state-key "d" 'show-pot-dict-at-region)
  (set-evil-main-state-key "c" 'lsp-execute-code-action)
  (set-evil-main-state-key "S" 'lsp-java-open-super-implementation  )
  (set-evil-main-state-key "s" 'lsp-goto-implementation  )
  (set-evil-main-state-key "o" 'other-window  )
  (set-evil-main-state-key "m" 'restart-project  )
  (set-evil-main-state-key "p" 'treemacs  )



  (set-evil-main-state-key
   "/"
   #'(lambda()
       (interactive )
       (cond
        ((check-in-php-mode)
         (progn
           (helm-projectile-grep (concat (projectile-project-root) "src/app" ) )
           ))
        (t  (spacemacs/helm-project-smart-do-search) ) ;; flycheck-disable-line
        )))

  (set-evil-main-state-key
   "i"
   #'(lambda()
       (interactive )
       (flycheck-explain-error-at-point   )
       (cond
        ((check-in-php-mode)
         (progn
           (ac-php-show-tip)
           ))
        (t
         (progn
           (setq lsp-ui-doc-show-with-cursor t)
           (lsp-ui-doc-show)
           (setq lsp-ui-doc-show-with-cursor nil)
           ))
        )))

  (set-evil-main-state-key "\""
                           #'(lambda()
                               (interactive )
                               (if (ac-php--in-string-or-comment-p)
                                   (cond
                                    ((check-in-php-mode)
                                     (progn

                                       (insert  "\" . \"")
                                       (backward-char 4 )
                                       ))
                                    )
                                 (progn ;;单词加双引号
                                   (save-excursion
                                     (backward-word)
                                     (insert "\"")
                                     (forward-word)
                                     (insert "\"")
                                     )
                                   )
                                 )))

  (set-evil-main-state-key
   ":"
   #'(lambda()
       (interactive )
       (let ( cur_word)
         (message "xxx")
         (save-excursion
           (setq  cur_word (current-word ))
           (backward-word)
           (insert "\"")
           (forward-word)
           (insert (concat "\" => $" cur_word  "," ))
           )
         )
       ))

  (set-evil-main-state-key
   ","
   #'(lambda()
       (interactive )
       (let (line-txt)
         (when (string= major-mode "go-mode")
           (save-excursion
             (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
             (beginning-of-line)
             (re-search-forward  "[a-zA-Z)_](" )
             (if (s-starts-with-p "func" line-txt )
                 (insert "ctx context.Context, ")
               (insert "ctx, ")
               )
             ))
         )))



  (set-evil-all-state-key (kbd "C-S-j")    'switch-file-term)

  (add-hook 'html-mode-hook 'zencoding-mode)
  (add-hook 'vue-mode-hook 'zencoding-mode)

  (add-hook 'php-mode-hook
            #'(lambda ( )
                (php-ts-mode)
                ))

  (add-hook 'php-mode-hook
            #'(lambda ( )
                (set-evil-main-state-key-on-mode php-mode-map "D" 'my-jump-table-sql  )
                (set-evil-main-state-key-on-mode  php-mode-map "r" 'ac-php-remake-tags )
                (set-evil-main-state-key-on-mode  php-mode-map "f" 'ac-php-gen-def )
                (set-evil-main-state-key-on-mode  php-mode-map "m" 'php-mode-make)
                ))
  (add-hook 'php-ts-mode-hook
            #'(lambda ( )
                (require 'company-php)
                (company-mode t)
                (add-to-list 'company-backends 'company-ac-php-backend)
                (add-hook 'php-mode-hook 'ac-php-core-eldoc-setup)

                (flycheck-mode)
                (set-evil-main-state-key-on-mode php-ts-mode-map "D" 'my-jump-table-sql  )

                (set-evil-main-state-key-on-mode  php-ts-mode-map "r" 'ac-php-remake-tags )
                (set-evil-main-state-key-on-mode  php-ts-mode-map "f" 'ac-php-gen-def )
                (set-evil-main-state-key-on-mode  php-ts-mode-map "m" 'php-mode-make)
                ))


  (set-evil-main-state-key-on-mode  java-mode-map "m" 'restart-project)
  (set-evil-main-state-key-on-mode  java-mode-map "t" 'maven-test-method)
  ;;(set-evil-main-state-key-on-mode  dart-mode-map "m" 'flutter-monitor )



  )

(defun my-user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ;; 加载核心 key绑定
  (set-main-key )

  (set-buffer-file-coding-system 'utf-8)
  (add-to-list 'file-coding-system-alist '("\\.php" . utf-8) )
  (add-to-list 'file-coding-system-alist '("\\.go" . utf-8) )

  (setq left-fringe-width 48)

  (setq indent-tabs-mode nil)
  (setq tab-width 4)

  (setq my-keyboard-input-dev (s-trim (shell-command-to-string (concat  (getenv "HOME") "/desktop/key_send/get_kbd_eventid.sh" )) ))

  ;; 关闭 生成 .#filename 文件
  (setq create-lockfiles nil)


  (add-to-list 'auto-mode-alist '("\\.wxml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.wxss\\'" . css-mode))


  ;;关闭 lsp-ui-doc
  (setq lsp-ui-doc-mode nil)
  (setq lsp-ui-doc-delay 1)
  (setq lsp-eldoc-enable-hover nil  )
  (setq lsp-ui-doc-show-with-cursor  nil)
  (setq lsp-ui-sideline-delay 10000 )
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-enable-xref nil)
  (setq lsp-enable-indentation t )
  (setq lsp-auto-execute-action nil)
  (setq lsp-debounce-full-sync-notifications nil)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-enable-folding nil)
  ;; (setq lsp-java-workspace-dir "/home/jim/java_workspace/" )
  (setq lsp-java-vmargs '("-noverify" "-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-javaagent:/home/jim/.spacemacs.d/bin/lombok-1.18.24.jar" "-Xbootclasspath/a:/home/jim/.spacemacs.d/bin/lombok-1.18.24.jar"))
  ;;  (setq lsp-java-vmargs '("-noverify" "-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-javaagent:/home/jim/.spacemacs.d/bin/lombok-1.18.24.jar" ))
  ;; ;; (setq lsp-java-vmargs '("-noverify" "-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication" ))

  ;; (setq dart-indent-trigger-commands '())

  ;;(setq    nil)



  (setq flycheck-navigation-minimum-level 'warning)


  (require 'evil)
  (require 'f)


  (global-set-key (kbd "<f8>")    'switch-file-term)
  (global-set-key (kbd "C-S-j")    'switch-file-term)


  (global-set-key (kbd "s-x")    'helm-M-x )
  (set-evil-all-state-key "\C-^"  'helm-mini )

  (global-set-key (kbd "C-:")    'company-files  )
  (set-evil-all-state-key (kbd "C-x C-k")    'kill-buffer )
  (set-evil-all-state-key "\C-]"  'spacemacs/jump-to-definition )
  ( set-evil-normal-state-key "Y"  'copy-region-or-whole-line )
  ( set-evil-normal-state-key "F"  'copy-field-list )
  ( set-evil-virtual-state-key "Y"  'copy-region-or-whole-line )
  ( set-evil-virtual-state-key "F"  'copy-field-list )
  (set-evil-normal-state-key "D"  'kill-region-or-whole-line )
  ( set-evil-virtual-state-key "D" 'kill-region-or-whole-line  )
  (require 'company)
  ;;(setq flycheck-check-syntax-automatically 'save )
  ;;(setq flycheck-check-syntax-automatically 'idle-change )
  ;;(setq  flycheck-idle-change-delay 800 )

  (define-key company-active-map  (kbd  "C-N")   'company-select-next )
  (define-key company-active-map  (kbd  "C-P")   'company-select-previous )
  ;;test
  (define-key company-active-map  (kbd  "C-1")   #'(lambda()
                                                     (interactive )
                                                     (describe-key (kbd "C-N" ) )
                                                     ) )


  (define-key evil-insert-state-map  (kbd  "C-P")   #'(lambda(&optional arg)
                                                        (interactive "p")
                                                        (if (company--active-p)
                                                            (company-select-previous arg)
                                                          (evil-complete-previous)
                                                          )
                                                        ))

  (define-key evil-insert-state-map  (kbd  "C-N")   #'(lambda(&optional arg)
                                                        (interactive "p")
                                                        (if (company--active-p)
                                                            (company-select-next arg)
                                                          (evil-complete-next arg)
                                                          )
                                                        ))





  (global-set-key (kbd  "C-/"  ) nil)
                                        ;(require 'undo-tree)
                                        ;(define-key undo-tree-map (kbd "C-/")  nil)
  (global-set-key  (kbd  "C-/"  )   'comment-or-uncomment-region-or-whole-line )




  (global-set-key (kbd "M-w")   'copy-region-or-whole-line)
  (global-set-key (kbd "s-w")   'copy-region-or-whole-line)


  (add-hook 'go-mode-hook #'(lambda ( )


                              (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )

                              ))
  (add-hook 'web-mode-hook #'(lambda ( )
                               (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                               ))
  (add-hook 'python-mode-hook #'(lambda()
                                  (my-set-evil-not-insert-local-map "="  'align-eq )
                                  (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                                  ))

  (add-hook 'vue-mode-hook #'(lambda ( )
                               (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                               (my-set-evil-not-insert-local-map "="  'align-eq )

                               (setq company-backends '(company-capf) )
                               ))

  (add-hook 'org-mode-hook #'(lambda ( )
                               (setq evil-org-key-theme
                                     `(textobjects
                                       navigation
                                       ;;additional
                                       ;;,@(when org-want-todo-bindings '(todo))
                                       ))
                               (evil-org-set-key-theme evil-org-key-theme)

                               ;; (defun evil-org--populate-additional-bindings ()
                               ;;   )


                               ))



  (add-hook 'php-mode-hook #'(lambda ( )

                               (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )

                               (my-set-evil-not-insert-local-map "g\C-]"   'my-jump-merber-class )
                               (my-set-evil-not-insert-local-map "="  'align-eq )

                               ))

  (add-hook 'php-ts-mode-hook #'(lambda ( )

                                  (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )

                                  (my-set-evil-not-insert-local-map "g\C-]"   'my-jump-merber-class )
                                  (my-set-evil-not-insert-local-map "="  'align-eq )

                                  ))

  (add-hook 'typescript-mode-hook #'(lambda ( )
                                      (vue-mode) ;;
                                      ;; (if(get-project-root-dir "vite.config.ts"  )
                                      ;;    (progn
                                      ;;      (vue-mode) ;;
                                      ;;     )
                                      ;;   (progn
                                      ;;     (my-set-evil-not-insert-local-map "="  'align-eq )
                                      ;;     (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )))
                                      ))

  (add-hook 'lua-mode-hook #'(lambda ( )
                               (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                               ))

  (add-hook 'rust-mode-hook #'(lambda ( )
                                (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                                ))


  (add-hook 'java-mode-hook #'(lambda ( )


                                ;;(xref-pop-marker-stack)
                                ;; (my-set-evil-local-map  "\C-t"      'meghanada-back-jump)
                                (my-set-evil-local-map  "\C-t"      'xref-pop-marker-stack)

                                (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                                ))

  (add-hook 'js-mode-hook #'(lambda ( )
                              (vue-mode)
                              ))




  (define-key evil-normal-state-map [escape] #'(lambda()
                                                 (interactive )
                                                 (if (string= major-mode "term-mode" )
                                                     (let()
                                                       (term-send-esc )
                                                       )
                                                   (fcitx-inactivate-input-method)
                                                   (evil-force-normal-state)
                                                   (lsp-ui-doc-hide)
                                                   )

                                                 ))



  (define-key evil-normal-state-map "gf" 'my-goto-file )
  (define-key evil-insert-state-map [escape] #'(lambda()
                                                 (interactive )
                                                 (if (string= major-mode "term-mode" )
                                                     (let()
                                                       (term-send-esc )
                                                       )
                                                   (fcitx-inactivate-input-method)
                                                   (evil-normal-state)

                                                   )
                                                 ))

  ;; (spacemacs|create-align-repeat-x "my-align" "=>" nil t)

  (global-set-key "\M-1" 'my-delete-other-windows)
  (global-set-key (kbd "s-/") 'hippie-expand)
  (global-set-key  (kbd "s-1") 'my-delete-other-windows)
  (global-set-key  (kbd "C-S-W") 'evil-yank )
  (global-set-key  (kbd "C-x C-e")
                   #'(lambda( eval-last-sexp-arg-internal)(interactive "P")
                       (cond
                        ((string= major-mode "emacs-lisp-mode")
                         (eval-last-sexp eval-last-sexp-arg-internal)
                         )
                        ((string= major-mode "sql-mode")


                         (unless mark-active

                           (beginning-of-line  )
                           (push-mark  (line-end-position) nil t  )
                           )


                         (if (>  (-  (region-end) (region-beginning)) 2)
                             (lsp-sql-execute-query)
                           (message " null ")
                           )
                         )

                        (t (let (line-txt ret)

                             (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                             (setq ret (shell-command-to-string  (concat  "echo 'print  " line-txt  "' | python 2>&1" )))
                             (message "exec : %s \n=>%s" line-txt ret )

                             )))))

  (set-evil-all-state-key  (kbd "C-<tab>")  #'(lambda () (interactive)
                                                (if  (check-in-php-mode)
                                                    (company-complete)
                                                  (company-complete))
                                                ))
  (set-evil-all-state-key  (kbd "M-1")  'my-delete-other-windows)
  (set-evil-all-state-key  (kbd "M-h") 'backward-kill-word-without-_)
  (set-evil-all-state-key  (kbd "C-h") 'delete-backward-char)
  (set-evil-all-state-key  (kbd "s-h") 'backward-kill-word-without-_)
  (set-evil-all-state-key (kbd "C-v") 'yank )
  (set-evil-all-state-key (kbd "C-c") 'copy-region-or-whole-line )
  (set-evil-all-state-key (kbd "C-S-h") 'multi-term-prev )
  (set-evil-all-state-key (kbd "C-S-l") 'multi-term-next )

  ;;查找时,使用trim-string,去掉前后空格
  (define-key isearch-mode-map (kbd "C-y")  #'(lambda()(interactive)
                                                (isearch-yank-string (trim-string (current-kill 0) ))))

  (define-key isearch-mode-map (kbd "C-v")  #'(lambda()(interactive)
                                                (isearch-yank-string (trim-string (current-kill 0) ))))

  (dolist (mode-hook (list
                      'sh-mode-hook
                      'json-mode-hook
                      'emacs-lisp-mode-hook
                      ))

    (add-hook mode-hook #'(lambda() (interactive )
                            (flycheck-mode)
                            (company-mode)

                            (my-set-evil-local-map  "\C-t"      'xref-pop-marker-stack )
                            ))
    )



  (add-hook 'Info-mode-hook
            #'(lambda()

                (define-key Info-mode-map (kbd "<return>")  'Info-follow-nearest-node )
                (define-key Info-mode-map (kbd "P")  'Info-next )

                ))

  ;; (add-hook 'vue-mode-hook
  ;;           '(lambda()
  ;;              (web-mode)
  ;;              ))



  (define-key   evil-ex-search-keymap  (kbd "C-y")  #'(lambda()(interactive)
                                                        (insert (trim-string (current-kill 0) ))))
  (define-key    evil-ex-search-keymap (kbd "C-v")  #'(lambda()(interactive)
                                                        (insert (trim-string (current-kill 0) ))))



  (define-key  minibuffer-inactive-mode-map (kbd "M-p")  'previous-line-or-history-element)
  (define-key  minibuffer-inactive-mode-map (kbd "M-n")  'next-line-or-history-element)

  (define-key  minibuffer-inactive-mode-map (kbd "s-p")  'previous-line-or-history-element)
  (define-key  minibuffer-inactive-mode-map (kbd "s-n")  'next-line-or-history-element)


  (define-key  minibuffer-inactive-mode-map (kbd "C-p")  'previous-line-or-history-element)
  (define-key  minibuffer-inactive-mode-map (kbd "C-n")  'next-line-or-history-element)
  (define-key  company-active-map (kbd "s-p")  'company-select-previous)
  (define-key  company-active-map (kbd "s-n")  'company-select-next)

  (define-key  company-search-map (kbd "s-p")  'company-select-previous)
  (define-key  company-search-map (kbd "s-n")  'company-select-next)





  ;;ex 命令行调整
  (evil-ex-define-cmd  "wq"  #'(lambda ()
                                 (interactive )
                                 (save-buffer )
                                 (multi-term-goto-last-term )
                                 ))

  (evil-ex-define-cmd  "q"  #'(lambda ()
                                (interactive )
                                (multi-term-goto-last-term )
                                ))



  (message "do user-config" )
  (server-start)

  (setq ac-php-project-root-dir-use-truename   nil )
  (setq flycheck-phpmd-rulesets (list  (concat (getenv "HOME") "/spacemacs-config/phpmd.xml"  ) ))
  (setq lsp-flycheck-enable-unnecessary-info nil)


  (setq frame-title-format  '("file: %f "  ))
  (setq yas-snippet-dirs   (list  "~/.spacemacs.d/my-yas"  )  )


  ( setq phpcbf-standard (concat (getenv "HOME") "/spacemacs-config/ruleset.xml" ))
  (setq phpcbf-executable (concat (getenv "HOME") "/spacemacs-config/bin/phpcbf" ) )


  ;; ;; 设置sqlfmt : cnpm install -g sql-formatter
  ;; (setq sqlfmt-executable  "sql-formatter")
  ;; (setq sqlfmt-options  '())




  (add-hook
   'term-mode-hook
   #'(lambda()
       (eterm-256color-mode)
       (yas-minor-mode -1 )
       ;; (message "=== selected: %s"  (selected-frame )  )
       ;;  (set-face-attribute 'default (selected-frame ) :font "MesloLGS NF:weight=normal")
       ;; (set-face-attribute 'default (selected-frame ) :font "XHei Mono.Ubuntu:weight=normal")

       (define-key evil-insert-state-local-map   (kbd "C-y")  'term-paste )
       (define-key evil-insert-state-local-map   (kbd "C-v")  'term-paste )
       (define-key evil-insert-state-local-map   (kbd "s-v")  'term-paste )
       (define-key evil-insert-state-local-map   (kbd "C-c")  'copy-region-or-whole-line  )
       (define-key evil-insert-state-local-map   (kbd "C-S-c")  'term-interrupt-subjob   )
       (define-key evil-insert-state-local-map   (kbd "C-p")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-n")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-a")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-e")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-h")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-l")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-k")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-u")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-w")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-d")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-t")  'term-send-raw)
       (define-key evil-insert-state-local-map   (kbd "C-s")  #'(lambda() (interactive) ))
       (define-key evil-insert-state-local-map   (kbd "M-h")  'term-send-backward-kill-word )
       (define-key evil-insert-state-local-map   (kbd "s-h")  'term-send-backward-kill-word )

       (setq term-unbind-key-list  '("C-x"))
       (setq term-bind-key-alist nil)

       (add-to-list 'term-bind-key-alist '("M-1" .  my-delete-other-windows ))
       (add-to-list 'term-bind-key-alist '("s-1" .  my-delete-other-windows ))

       ;;(add-to-list 'term-bind-key-alist '("C-^" .  helm-mini ))
       (add-to-list 'term-bind-key-alist '("M-x" .  helm-M-x ))
       (add-to-list 'term-bind-key-alist '("s-x" .  helm-M-x ))
       (add-to-list 'term-bind-key-alist '("C-^" .  helm-mini ))

       ;;(add-to-list 'term-bind-key-alist '("s-x" . counsel-M-x  ))
       ;;(add-to-list 'term-bind-key-alist '("M-x" . counsel-M-x  ))
       ;;(add-to-list 'term-bind-key-alist '("C-^" .  ivy-switch-buffer ))

       ;; C-6 -> C-^
       (add-to-list 'term-bind-key-alist '( "C-6". (lambda() (interactive)  (term-send-raw-string "\C-^" ) ) ))

       (add-to-list 'term-bind-key-alist '( "C-S-t". (lambda() (interactive) (multi-term)  ) ))
       (add-to-list 'term-bind-key-alist '( "C-S-h". (lambda() (interactive) (multi-term-prev 1 )   ) ))
       (add-to-list 'term-bind-key-alist '( "C-S-l". (lambda() (interactive) ( multi-term-next 1 )   ) ))
       (add-to-list 'term-bind-key-alist '( "C-S-D". my-join-line  ))


       ;;(add-to-list 'term-bind-key-alist '( "C-c".  copy-region-or-whole-line  ))
       (add-to-list 'term-bind-key-alist '( "M-w". copy-region-or-whole-line ))
       (add-to-list 'term-bind-key-alist '( "s-w". copy-region-or-whole-line ))
       ;;(add-to-list 'term-bind-key-alist '( "C-v". term-paste ))
       ;;(add-to-list 'term-bind-key-alist '( "C-y". term-paste ))
       ;;(add-to-list 'term-bind-key-alist '( "<up>". term-send-raw ))
       ))


  (evilmi-load-plugin-rules '(web-mode
                              vue-mode
                              html-mode
                              nxml-mode
                              nxhtml-mode
                              sgml-mode
                              php-mode
                              message-mode
                              mhtml-mode)
                            '(simple  template html))

  (setq flycheck-idle-change-delay  5)
  (setq company-idle-delay              1000)

  (setq flycheck-display-errors-delay  1300000)
  (setq flycheck-check-syntax-automatically '( save
                                               idle-change
                                               new-line
                                               mode-enabled))

                                        ;(setq undo-tree-auto-save-history nil)


  (setq multi-term-program "/bin/bash")
  (setq multi-term-program "/bin/zsh")
  (add-to-list 'auto-mode-alist '( "\\.blade\\.php\\'" . web-mode))

  (set-frame-position (selected-frame) 1920 0)
  (set-frame-width (selected-frame) 80)
  (set-frame-height (selected-frame) 110)
  ;; (recentf-load-list)

  ;; 指定
  (setq ccls-initialization-options
        `(:clang (:extraArgs ["--gcc-toolchain=/home/jim/pico/arm-none-eabi-gcc/arm-none-eabi/bin/" "--sysroot=/home/jim/pico/arm-none-eabi-gcc/arm-none-eabi/"])))

  (evil-declare-change-repeat 'company-complete-common)

  )




(provide 'my-config)

;;; my-config.el ends here
