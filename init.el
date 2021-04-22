;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.
;;; Code:

(setq-default  my-font-size 24 )

(load  (expand-file-name "init-ex.el" dotspacemacs-directory) t t  t nil )

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(elixir
     systemd
     (rust :variables rust-backend 'lsp)
     react
     csv
     python
     nginx
     sql
     windows-scripts
     (dart
      :variables dart-server-sdk-path  (concat (getenv "HOME") "/flutter/bin/cache/dart-sdk/")
      )
     lua
     vimscript
     git
     docker
     (auto-completion :variables
                      auto-completion-enable-help-tooltip t
      )
     yaml
     ;;erlang
     php
     (go :variables
         go-tab-width 4
         gofmt-command "goimports"
         godoc-at-point-function 'godoc-gogetdoc
         go-backend 'go-mode
         ;;go-use-golangci-lint t
         ;;go-use-gometalinter t
         )
     html

     (typescript :variables
                 typescript-backend 'tide
                 typescript-fmt-on-save t)
     ;; elixir
     (java :variables java-backend 'meghanada)
     ;;(java )
     ruby
     javascript
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;;ivy
     helm

     (chinese :variables
              chinese-enable-youdao-dict t
              )

     protobuf

     better-defaults
     emacs-lisp
     ;; git
      markdown
      org
     ;; (shell :variables
     ;;       shell-default-height 30
     ;;      shell-default-position 'bottom)
     ;; spell-checking
      syntax-checking
     ;; version-control
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(vue-mode   async  js2-mode web-mode typescript-mode  multi-term xcscope )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '( php-extras auto-highlight-symbol version-control
                                                yasnippet-snippets
                                                chinese-pyim
                                                ;;go-eldoc
                                                pyim
                                                ace-pinyin
                                                phpactor
                                                company-phpactor
                                                )
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))


(defun dotspacemacs/init ()


  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(tsdh-dark  spacemacs-dark
                         spacemacs-light)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   ;;(if (string= (system-name) "jim-MacBookPro") 48 24  )
  dotspacemacs-default-font (list  "XHei Mono.Ubuntu"  ;;"Source Code Pro"
                                   ;;:size  (if (string= (system-name) "jim-PC" )  48 24  )
                                   :size (max (round(* my-font-size (string-to-number (shell-command-to-string "grep ScreenScaleFactors  ~/.config/deepin/qt-theme.ini | awk -F= '{print $2}' ") ))) my-font-size )

                                   :weight 'normal
                                   :width 'normal
                                   :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."

(message "load user-init ===========")

 (setq configuration-layer-elpa-archives
     '(("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
     ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
     ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))

  )



(setq custom-file (expand-file-name "custom.el" dotspacemacs-directory) )
(load custom-file )
(load  (expand-file-name "init-syntax-table.el" dotspacemacs-directory) )
(load  (expand-file-name "xcwen-misc.el" dotspacemacs-directory) )
(load  (expand-file-name "php-cs-fixer.el" dotspacemacs-directory) )
;;(defun dotspacemacs/user-config )
(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."
  (setq eclim-eclipse-dirs '("~/eclipse") )
  (setq
   ;; Specify the workspace to use by default
   eclimd-default-workspace "~/eclipse-workspace"
   ;; wether autostarting eclimd or not (default nil)
   eclimd-autostart t
   ;; Whether or not to block emacs until eclimd is ready (default nil)
   eclimd-wait-for-process t)
  (set-buffer-file-coding-system 'utf-8)
  (add-to-list 'file-coding-system-alist '("\\.php" . utf-8) )
  (add-to-list 'file-coding-system-alist '("\\.go" . utf-8) )

  ;; google translate
  (require 'google-translate)


  ;;If google-translate-enable-ido-completion is non-NIL, the input will be read with ido-style completion.
  (setq-default google-translate-enable-ido-completion t)

  (setq-default google-translate-default-source-language "en")
  (setq-default google-translate-default-target-language "zh-CN")
  (require 'font-lock+ )

  (setq go-format-before-save t)


  (load  (expand-file-name "php-align.el" dotspacemacs-directory) )
  (load  (expand-file-name "js2-align.el" dotspacemacs-directory) )
  (load  (expand-file-name "helm-ac-php-apropros.el" dotspacemacs-directory) )
  (dolist (mode (list
                 'emacs-lisp-mode
                 'php-mode
                 'js2-mode
                 'vue-mode
                 'markdown-mode
                 'typescript-mode
                 'typescript-tsx-mode
                 'fundamental-mode
                 'web-mode
                 'scss-mode
                 'c-mode
                 'sql-mode
                 'json-mode
                 'dart-mode
                 'go-mode
                 'org-mode
                 'sh-mode
                 'js2-mode
                 'java-mode
                 'conf-javaprop-mode
                 'conf-mode
                 'ruby-mode
                 ;'elixir-mode
                 'yaml-mode
                 'dotenv-mode
                 'nxml-mode
                 'toml-mode
                 ;;'erlang-mode
                 'rust-mode
                 'html-mode
                 'conf-unix-mode
                 'lua-mode
                 'nginx-mode
                 'css-mode
                 'help-mode
                 'text-mode
                 'python-mode
                 'protobuf-mode
                 'makefile-gmake-mode
                 'conf-space-mode
                 'latex-mode
                 'dockerfile-mode
                 'gitignore-mode
                 ))
    (spacemacs/set-leader-keys-for-major-mode  mode "w" 'save-buffer)
    (spacemacs/set-leader-keys-for-major-mode  mode "d" 'youdao-dictionary-search-at-point-tooltip )
    (spacemacs/set-leader-keys-for-major-mode  mode "W" '(lambda()
                                                           (interactive )
                                                           (whitespace-cleanup)
                                                           (save-buffer )  )  )

    (spacemacs/set-leader-keys-for-major-mode  mode "u" 'upper-or-lower-whole-word)
    (spacemacs/set-leader-keys-for-major-mode  mode "L" 'revert-buffer )
    (spacemacs/set-leader-keys-for-major-mode  mode "a" 'switch-file-opt )
    (spacemacs/set-leader-keys-for-major-mode  mode "A" 'switch-file-opt-proto )
    (spacemacs/set-leader-keys-for-major-mode  mode "o" 'other-window )
    (when  (string= mode 'php-mode)
      (spacemacs/set-leader-keys-for-major-mode  mode "D" 'my-jump-table-sql )
      )

    (unless (string= mode 'go-mode)
      (spacemacs/set-leader-keys-for-major-mode  mode "e" 'cleanup-and-goto-error)

        )
      (spacemacs/set-leader-keys-for-major-mode  mode "\""
      ;;(spacemacs/set-leader-keys-for-major-mode 'php-mode  "\""
      '(lambda()
         (interactive )
         (if (ac-php--in-string-or-comment-p)
             (cond
              ((string= major-mode "php-mode")
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

    )


  ;;(define-key evil-motion-state-map (kbd "*") 'evil-ex-search-word-forward)
  (spacemacs/set-leader-keys-for-major-mode  'php-mode "r" 'ac-php-remake-tags )
  (spacemacs/set-leader-keys-for-major-mode  'php-mode "i" 'ac-php-show-tip)
  (spacemacs/set-leader-keys-for-major-mode  'php-mode "f" 'ac-php-gen-def )
  (spacemacs/set-leader-keys-for-major-mode  'php-mode "m" 'php-mode-make)
  (spacemacs/set-leader-keys-for-major-mode  'protobuf-mode "m" 'core-server-make )
  (spacemacs/set-leader-keys-for-major-mode  'go-mode "m" 'go-core-server-make )
  (spacemacs/set-leader-keys-for-major-mode  'dart-mode "m" 'flutter-run-or-hot-reload )

  (spacemacs/set-leader-keys-for-major-mode  'java-mode "f" 'java-gen-get-set-code  )

  (spacemacs/set-leader-keys-for-major-mode  'emacs-lisp-mode "," nil)
;  (setq flycheck-erlang-include-path '(
;
;                                       "/home/jim/ejabberd-17.08/deps/xmpp/include"
;                                       "/home/jim/ejabberd-17.08/deps/fast_xml/include"
;                                       "/home/jim/ejabberd-17.08/deps/lager/include"
;                                       "/home/jim/ejabberd-17.08/deps/cache_tab/include"
;                                       "/home/jim/ejabberd-17.08/deps/p1_utils/include"
;                                       "/home/jim/ejabberd-17.08/include"
;
;                                       ) )


  ;;(edts-project-override "~/my-project" (:name "my-project-dev"
   ;;                                              :node-name "my-project-dev"))




  (add-hook 'vue-mode-hook '(lambda ( )
                                (web-mode )
                              ))
  (add-hook 'php-mode-hook '(lambda ( )
                              (require 'php-align)
                              (php-align-setup)
                              (require 'helm-ac-php-apropros)

                              (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )

                              (my-set-evil-not-insert-local-map "g\C-]"   'my-jump-merber-class )
                              ))
  (add-hook 'go-mode-hook '(lambda ( )


                             (setq go-packages-function  'go-packages-native)
                             (setq go-packages-function   'my-go-packages-gopkgs)
                              (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )

                              (spacemacs/set-leader-keys-for-major-mode  'go-mode "e" 'cleanup-and-goto-error)
                              (spacemacs/set-leader-keys-for-major-mode  'go-mode "r" '(lambda()
                                                                                     (interactive )
                                                                                     (shell-command "killall -9 gocode" )
                                                                                     ))

                              ))


  (add-hook 'python-mode-hook '(lambda ( )
                              (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                              (my-set-evil-local-map  "\C-t"      'anaconda-mode-go-back )
                              ))

  (add-hook 'java-mode-hook '(lambda ( )
                                 (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                                 (my-set-evil-local-map  "\C-t"      'meghanada-back-jump )

                                 (set (make-local-variable 'company-backends)
                                      '(company-meghanada ))
                                 ))

  (add-hook 'js2-mode-hook '(lambda ( )
                              (require 'js2-align)
                              (js2-align-setup)
                              (spacemacs/set-leader-keys-for-major-mode  js2-mode "w" 'save-buffer)
                              (setq js2-strict-trailing-comma-warning nil )
                              (setq js2-strict-missing-semi-warning  nil)
                              ))
  (add-hook 'typescript-mode-hook '(lambda ( )
                                     (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                                     (my-set-evil-local-map "\C-]"   'tide-jump-to-definition )

                                     ))


  (add-hook 'erlang-mode-hook '(lambda ( )
                                     (my-set-evil-local-map "\C-]"   'edts-find-source-under-point )

                                     ))



  (add-hook
   'org-mode-hook
   '(lambda ( )
      (my-set-evil-local-map (kbd "C-S-j")     'switch-file-term )
      ))



  (add-hook
   'web-mode-hook
   '(lambda ( )
      (my-set-evil-local-map "\C-]"   'tide-jump-to-definition )
      ))


  ;;关闭 lsp-ui-doc
  (setq lsp-ui-doc-delay 100000)
  (setq lsp-ui-sideline-delay 10000 )
  (setq lsp-eldoc-enable-hover nil)
  (setq lsp-eldoc-enable-signature-help nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-xref nil)
  (setq lsp-enable-indentation nil )
  (setq lsp-eldoc-prefer-signature-help nil)
  (setq lsp-enable-on-type-formatting  nil)
  (setq lsp-eldoc-hook nil )
  (setq lsp-enable-indentation  nil)
  (setq lsp-links-check-internal 10000)
  (setq lsp-enable-links nil)
  (setq lsp-auto-execute-action nil)
  (setq lsp-debounce-full-sync-notifications nil)
  (setq lsp-enable-file-watchers nil)
  (setq lsp-enable-folding nil)
  (setq dart-server-enable-analysis-server nil )
 ;;(setq    nil)



  ;;关闭tide warning

  ;;(setq tide-filter-out-warning-completions t)
  (setq flycheck-navigation-minimum-level 'warning)
  ;;(setq tide-tsserver-executable  "node_modules/typescript/bin/tsserver" )


  (require 'evil)
  (require 'f)


  (global-set-key (kbd "<f8>")    'switch-file-term)
  (global-set-key (kbd "C-S-j")    'switch-file-term)

  ;;(global-set-key (kbd "s-x")    'counsel-M-x )
  ;;(set-evil-all-state-key "\C-^"  'ivy-switch-buffer )

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
  (define-key company-active-map  (kbd  "C-1")   '(lambda()
                                                    (interactive )
                                                    (describe-key (kbd "C-N" ) )
                                                    ) )


  (define-key evil-insert-state-map  (kbd  "C-P")   '(lambda(&optional arg)
                                                       (interactive "p")
                                                       (if (company--active-p)
                                                           (company-select-previous arg)
                                                         (evil-complete-previous)
                                                         )
                                                        ))

  (define-key evil-insert-state-map  (kbd  "C-N")   '(lambda(&optional arg)
                                                       (interactive "p")
                                                       (if (company--active-p)
                                                           (company-select-next arg)
                                                         (evil-complete-next arg)
                                                         )
                                                       ))



  ;; (when (check-in-linux )
  ;;   (x-send-client-message
  ;;    nil 0 nil "_NET_WM_STATE" 32
  ;;    '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  ;;   (x-send-client-message
  ;;    nil 0 nil "_NET_WM_STATE" 32
  ;;    '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)) )



  (global-set-key (kbd  "C-/"  ) nil)
  (require 'undo-tree)
  (define-key undo-tree-map (kbd "C-/")  nil)
  (global-set-key  (kbd  "C-/"  )   'comment-or-uncomment-region-or-whole-line )


  ;;(add-hook 'after-save-hook 'ts2js)


  (custom-set-faces
   '(term-color-blue ((t (:background "blue" :foreground "steel blue"))))
   '(term-color-green ((t (:background "green3" :foreground "lime green"))))
   '(term-color-red ((t (:background "red3" :foreground "brown")))))

  (global-set-key (kbd "M-w")   'copy-region-or-whole-line)
  (global-set-key (kbd "s-w")   'copy-region-or-whole-line)
;
  ;; 等号对齐
  (define-key evil-visual-state-map (kbd "=")
    '(lambda( beg end  )
       (interactive "r")

       ;;"多行注释处理"
       (if (and mark-active
                (string-match "\n"
                              (buffer-substring-no-properties (region-beginning)(region-end))))
           (progn
             (mark-region-ex)

             (setq beg (region-beginning) )
             (setq end (region-end) )
             ))
       (align beg end)
       ))


  (define-key evil-normal-state-map [escape] '(lambda()
                                                (interactive )
                                                (if (string= major-mode "term-mode" )
                                                    (let()
                                                      (term-send-esc )
                                                      )
                                                  (fcitx-inactivate-input-method)
                                                  (evil-force-normal-state)
                                                  )

                                                ))



  (define-key evil-normal-state-map "gf" 'my-goto-file )
  (define-key evil-insert-state-map [escape] '(lambda()
                                                (interactive )
                                                (if (string= major-mode "term-mode" )
                                                    (let()
                                                      (term-send-esc )
                                                      )
                                                  (fcitx-inactivate-input-method)
                                                  (evil-normal-state)

                                                  )
                                                ))

  (spacemacs|create-align-repeat-x "my-align" "=>" nil t)

  (global-set-key "\M-1" 'delete-other-windows)
  (global-set-key (kbd "s-/") 'hippie-expand)
  (global-set-key  (kbd "s-1") 'delete-other-windows)
  (global-set-key  (kbd "C-S-W") 'evil-yank )
  (global-set-key  (kbd "C-x C-e") '(lambda( eval-last-sexp-arg-internal)(interactive "P")
                                      (cond
                                       ((string= major-mode "emacs-lisp-mode")
                                        (eval-last-sexp eval-last-sexp-arg-internal)
                                       )
                                       (t (let (line-txt ret)

                                            (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                                            (setq ret (shell-command-to-string  (concat  "echo 'print  " line-txt  "' | python 2>&1" )))
                                            (message "exec : %s \n=>%s" line-txt ret )

                                          )))))

  (set-evil-all-state-key  (kbd "C-<tab>")  '(lambda () (interactive)
                                               (if  (string= major-mode "php-mode")
                                                   (company-complete)
                                                 (company-complete))
                                               ))
  (set-evil-all-state-key  (kbd "M-1")  'delete-other-windows)
  (set-evil-all-state-key  (kbd "M-h") 'backward-kill-word-without-_)
  (set-evil-all-state-key  (kbd "C-h") 'delete-backward-char)
  (set-evil-all-state-key  (kbd "s-h") 'backward-kill-word-without-_)
  (set-evil-all-state-key (kbd "C-v") 'yank )
  (set-evil-all-state-key (kbd "C-c") 'copy-region-or-whole-line )
  (set-evil-all-state-key (kbd "C-S-h") 'multi-term-prev )
  (set-evil-all-state-key (kbd "C-S-l") 'multi-term-next )

  ;;查找时,使用trim-string,去掉前后空格
  (define-key isearch-mode-map (kbd "C-y")  '(lambda()(interactive)
                                               (isearch-yank-string (trim-string (current-kill 0) ))))

  (define-key isearch-mode-map (kbd "C-v")  '(lambda()(interactive)
                                               (isearch-yank-string (trim-string (current-kill 0) ))))

  (dolist (mode-hook (list
                 'sh-mode-hook
                 'json-mode-hook
                 'emacs-lisp-mode-hook
                 ))

    (add-hook mode-hook '(lambda() (interactive )
                               (flycheck-mode)
                               (company-mode)
                               ))
    )



  (add-hook 'minibuffer-inactive-mode-hook
            '(lambda()
               ;;(message  "  XXXX  minibuffer-inactive-mode-hook ")
               ))
  (define-key   evil-ex-search-keymap  (kbd "C-y")  '(lambda()(interactive)
                                                       (insert (trim-string (current-kill 0) ))))
  (define-key    evil-ex-search-keymap (kbd "C-v")  '(lambda()(interactive)
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
  (evil-ex-define-cmd  "wq"  '(lambda ()
                                (interactive )
                                (save-buffer )
                                (multi-term-goto-last-term )
                                ))

  (evil-ex-define-cmd  "q"  '(lambda ()
                               (interactive )
                               (multi-term-goto-last-term )
                               ))



  (message "do user-config" )
  (server-start)

  (setq ac-php-project-root-dir-use-truename   nil )
  (setq flycheck-phpmd-rulesets (list  (concat (getenv "HOME") "/spacemacs-config/phpmd.xml"  ) ))
  (setq frame-title-format  '("file: %f "  ))
  (setq yas-snippet-dirs   (list  "~/.spacemacs.d/my-yas"  )  )



  (flycheck-disable-checker 'php-phpmd  nil)
  (custom-set-variables
   '(phpcbf-standard (concat (getenv "HOME") "/spacemacs-config/ruleset.xml" ))
   '(flycheck-phpcs-standard (concat (getenv "HOME") "/spacemacs-config/ruleset.xml" ))
  )

 ;; (custom-set-variables
 ;;  '(phpcbf-standard "PSR2" ))

  ;; Auto format on save.
  ;;(add-hook 'php-mode-hook 'phpcbf-enable-on-save)
  ;;(add-hook 'before-save-hook 'php-cs-fixer-before-save)

  ;;(require 'edts-start)

  ;;(add-hook 'buffer-list-update-hook 'set-admin-title  )

  (add-hook
   'term-mode-hook
   '(lambda()
      (yas-minor-mode -1 )

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
      (define-key evil-insert-state-local-map   (kbd "C-s")  '(lambda() (interactive) ))
      (define-key evil-insert-state-local-map   (kbd "M-h")  'term-send-backward-kill-word )
      (define-key evil-insert-state-local-map   (kbd "s-h")  'term-send-backward-kill-word )

      (setq term-unbind-key-list  '("C-x"))
      (setq term-bind-key-alist nil)

      (add-to-list 'term-bind-key-alist '("M-1" .  delete-other-windows ))
      (add-to-list 'term-bind-key-alist '("s-1" .  delete-other-windows ))

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
      (add-to-list 'term-bind-key-alist '( "C-S-w". my-join-line  ))


      ;;(add-to-list 'term-bind-key-alist '( "C-c".  copy-region-or-whole-line  ))
      (add-to-list 'term-bind-key-alist '( "M-w". copy-region-or-whole-line ))
      (add-to-list 'term-bind-key-alist '( "s-w". copy-region-or-whole-line ))
      ;;(add-to-list 'term-bind-key-alist '( "C-v". term-paste ))
      ;;(add-to-list 'term-bind-key-alist '( "C-y". term-paste ))
      ;;(add-to-list 'term-bind-key-alist '( "<up>". term-send-raw ))
      ))

  (evilmi-load-plugin-rules '(web-mode
                              html-mode
                              nxml-mode
                              nxhtml-mode
                              sgml-mode
                              php-mode
                              message-mode
                              mhtml-mode)
                            '(simple  template html))


  )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."

)



(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
  )
