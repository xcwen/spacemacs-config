;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.
;;; Code:

(setq-default  my-font-size 24 )
(setq-default  my-keyboard-input-dev "/dev/input/event7")

;;(load  (expand-file-name "init-ex.el" dotspacemacs-directory) t t  t nil )


(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
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
   '(clojure
     elixir
     systemd
     (lsp :variables lsp-rust-server 'rust-analyzer)
     (c-c++ :variables c-c++-backend 'lsp-clangd)

     (rust :variables rust-backend 'lsp)

     react
     csv
     ;;(python )
     (python :variables python-backend 'lsp
             python-lsp-server 'pyright
             )
     nginx

     (templates :variables templates-private-directory "~/.spacemacs.d/templates")
     (sql :variables
          sql-backend 'lsp
          sql-lsp-sqls-workspace-config-path 'workspace)
     windows-scripts
     (dart
      :variables dart-server-sdk-path  (concat (getenv "HOME") "/flutter/bin/cache/dart-sdk/")
      lsp-enable-on-type-formatting nil
      )
     (lua :variables
          lua-backend 'lsp
          lua-lsp-server 'emmy
          lsp-clients-emmy-lua-jar-path (concat (getenv "HOME")  "/.spacemacs.d/bin/EmmyLua-LS-all.jar") ; default path
          lsp-clients-emmy-lua-java-path "java") ; default path

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
         ;; gofmt-command "goimports
         ;; godoc-at-point-function 'godoc-gogetdoc
         go-backend 'lsp
         go-format-before-save t
         ;;go-use-golangci-lint t
         ;;go-use-gometalinter t
         )
     html

     (typescript :variables
                 typescript-backend 'tide
                 typescript-fmt-on-save t)
     ;; elixir
    ;; (java :variables java-backend 'meghanada)
      (java :variables java-backend 'lsp)
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
     helm
      markdown

     ;;multiple-cursors
      ;;(multiple-cursors :variables multiple-cursors-backend 'evil-mc)
      (org
       :variables org-enable-appear-support t)
     ;; (shell :variables
     ;;       shell-default-height 30
     ;;      shell-default-position 'bottom)
     ;; spell-checking
      syntax-checking
     ;; version-control
     treemacs)


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   ;;dotspacemacs-additional-packages '()
   dotspacemacs-additional-packages '(vue-mode  multi-term zencoding-mode eterm-256color )


   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '( php-extras
                                     ;;phpcbf
                                     ;; auto-highlight-symbol
             gendoxy
                                     version-control
                                     git-modes
                                     yasnippet-snippets
             php-auto-yasnippets

                                     chinese-pyim
                                     org-contrib
                                     ;;go-eldoc
                                     hybrid-mode
                                     evil-unimpaired
                                     forge
                                     company-go
                                     pyim
                                     ace-pinyin
                                     phpactor
                                     company-phpactor
                                     )
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))


(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

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
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   ;;dotspacemacs-themes '( tsdh-dark spacemacs-dark spacemacs-light)
   dotspacemacs-themes '( spacemacs-dark spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   ;;(if (string= (system-name) "jim-MacBookPro") 48 24  )
   dotspacemacs-default-font (list
                              ;;"MesloLGS NF"
                              "XHei Mono.Ubuntu"
                              ;;"Source Code Pro"
                                   ;;:size  (if (string= (system-name) "jim-PC" )  48 24  )
                                   :size (max (round(* my-font-size (string-to-number (shell-command-to-string "grep ScreenScaleFactors  ~/.config/deepin/qt-theme.ini | awk -F= '{print $2}' ") ))) my-font-size )

                                   :weight 'normal
                                   :width 'normal
                                   :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key nil
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

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

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-nameg
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Show trailing whitespace (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling likke has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil)
  )

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

(message "load user-init ===========")

 (setq configuration-layer-elpa-archives
     '(("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
     ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
     ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))

 ;; (setq url-proxy-services nil)
 ;; (setq url-proxy-services
 ;;       '(("no_proxy" . "^\\(localhost\\|10.*\\)")
 ;;         ("http" . "127.0.0.1:41091")
 ;;         ("https" . "127.0.0.1:41091")))
 ;; (setq lsp-java-jdt-download-url "http://127.0.0.1:8080/jdt-language-server-1.15.0-202208290205.tar.gz")
 ;; (setq  lsp-java--download-root  "http://127.0.0.1:8080/")

 ;; (setq lsp-java-jdt-download-url "https://download.eclipse.org/jdtls/milestones/1.12.0/jdt-language-server-1.12.0-202206011637.tar.gz")
)



(setq custom-file (expand-file-name "custom.el" dotspacemacs-directory) )
(load custom-file )
(load  (expand-file-name "init-syntax-table.el" dotspacemacs-directory) )
(load  (expand-file-name "xcwen-misc.el" dotspacemacs-directory) )
(defun set-main-key()

  (define-key evil-motion-state-map "," nil )

  (set-evil-main-state-key "w" 'save-buffer )

  (set-evil-main-state-key "u" 'upper-or-lower-whole-word)
  (set-evil-main-state-key "L" 'revert-buffer )
  (set-evil-main-state-key "a" 'switch-file-opt )
  (set-evil-main-state-key "A" 'switch-file-opt-proto )
  (set-evil-main-state-key "e" 'cleanup-and-goto-error)
  (set-evil-main-state-key "d" 'show-baidu-dict-at-region)
  (set-evil-main-state-key "c" 'lsp-execute-code-action)
  (set-evil-main-state-key "S" 'lsp-java-open-super-implementation  )
  (set-evil-main-state-key "s" 'lsp-java--show-implementations  )
  (set-evil-main-state-key "o" 'other-window  )
  (set-evil-main-state-key "m" 'restart-project  )
  (set-evil-main-state-key "p" 'treemacs  )



  (set-evil-main-state-key
   "/"
   '(lambda()
      (interactive )
      (cond
       ((string= major-mode "php-mode")
        (progn
            (helm-projectile-grep (concat (projectile-project-root) "src/app" ) )
          ))
       (t  (spacemacs/helm-project-smart-do-search) )
       )))

  (set-evil-main-state-key
   "i"
   '(lambda()
      (interactive )
      (flycheck-explain-error-at-point   )
      (cond
       ((string= major-mode "php-mode")
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


  (set-evil-all-state-key (kbd "C-S-j")    'switch-file-term)

  (add-hook 'html-mode-hook 'zencoding-mode)
  (add-hook 'vue-mode-hook 'zencoding-mode)




  (add-hook 'php-mode-hook
            '(lambda ( )
               (set-evil-main-state-key-on-mode php-mode-map "D" 'my-jump-table-sql  )

               (set-evil-main-state-key-on-mode  php-mode-map "r" 'ac-php-remake-tags )
               (set-evil-main-state-key-on-mode  php-mode-map "f" 'ac-php-gen-def )
               (set-evil-main-state-key-on-mode  php-mode-map "m" 'php-mode-make)
               ))

  (set-evil-main-state-key-on-mode  java-mode-map "m" 'restart-project)
  (set-evil-main-state-key-on-mode  java-mode-map "t" 'maven-test-method)
  (set-evil-main-state-key-on-mode  dart-mode-map "m" 'flutter-monitor )



  )

;;(load  (expand-file-name "php-cs-fixer.el" dotspacemacs-directory) )
;;(defun dotspacemacs/user-config )
(defun dotspacemacs/user-config ()
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


  (setq my-keyboard-input-dev (s-trim (shell-command-to-string (concat  (getenv "HOME") "/desktop/key_send/get_kbd_eventid.sh" )) ))

  ;; 关闭 生成 .#filename 文件
  (setq create-lockfiles nil)


  (setq lsp-python-ms-python-executable  "/usr/bin/python3")
  (require 'font-lock+ )



  (load  (expand-file-name "php-align.el" dotspacemacs-directory) )



  ;;关闭 lsp-ui-doc
  (setq lsp-ui-doc-delay 1)
  (setq lsp-ui-doc-show-with-cursor  nil)
  (setq lsp-ui-sideline-delay 10000 )
  (setq lsp-eldoc-enable-hover t)
  (setq lsp-eldoc-enable-signature-help nil)
  (setq lsp-enable-symbol-highlighting t)
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
  (setq lsp-java-vmargs '("-noverify" "-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-javaagent:/home/jim/.m2/repository/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar" "-Xbootclasspath/a:/home/jim/.m2/repository/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar"))
  (setq lsp-java-vmargs '("-noverify" "-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication" ))

  (setq dart-indent-trigger-commands '())

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





  (global-set-key (kbd  "C-/"  ) nil)
  (require 'undo-tree)
  (define-key undo-tree-map (kbd "C-/")  nil)
  (global-set-key  (kbd  "C-/"  )   'comment-or-uncomment-region-or-whole-line )




  (global-set-key (kbd "M-w")   'copy-region-or-whole-line)
  (global-set-key (kbd "s-w")   'copy-region-or-whole-line)


  (add-hook 'go-mode-hook '(lambda ( )


                             (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )

                             ))
  (add-hook 'web-mode-hook '(lambda ( )
                             (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                             ))

  (add-hook 'php-mode-hook '(lambda ( )
                              (require 'php-align)
                              (php-align-setup)

                              (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )

                              (my-set-evil-not-insert-local-map "g\C-]"   'my-jump-merber-class )
                              ))

  (add-hook 'typescript-mode-hook '(lambda ( )
                              (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                              ))

  (add-hook 'lua-mode-hook '(lambda ( )
                                     (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                                     ))

  (add-hook 'rust-mode-hook '(lambda ( )
                              (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                              ))


  (add-hook 'java-mode-hook '(lambda ( )


                               ;;(xref-pop-marker-stack)
                               ;; (my-set-evil-local-map  "\C-t"      'meghanada-back-jump)
                                (my-set-evil-local-map  "\C-t"      'xref-pop-marker-stack)

                               (my-set-evil-local-map "<tab>"   'yas-expand-for-vim )
                               ))

  (add-hook 'js-mode-hook '(lambda ( )
                             (typescript-mode)
                               ))





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
                                                  (lsp-ui-doc-hide)
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

  (global-set-key "\M-1" 'my-delete-other-windows)
  (global-set-key (kbd "s-/") 'hippie-expand)
  (global-set-key  (kbd "s-1") 'my-delete-other-windows)
  (global-set-key  (kbd "C-S-W") 'evil-yank )
  (global-set-key  (kbd "C-x C-e")
                   '(lambda( eval-last-sexp-arg-internal)(interactive "P")
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

  (set-evil-all-state-key  (kbd "C-<tab>")  '(lambda () (interactive)
                                               (if  (string= major-mode "php-mode")
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

                               (my-set-evil-local-map  "\C-t"      'xref-pop-marker-stack )
                               ))
    )



  (add-hook 'Info-mode-hook
            '(lambda()

               (define-key Info-mode-map (kbd "<return>")  'Info-follow-nearest-node )
               (define-key Info-mode-map (kbd "P")  'Info-next )

               ))

  (add-hook 'vue-mode-hook
            '(lambda()
               (web-mode)
               ))



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




  (custom-set-variables
   '(phpcbf-executable (concat (getenv "HOME") "/console_php_core/src/vendor/bin/phpcbf" ) )
   '(phpcbf-standard (concat (getenv "HOME") "/spacemacs-config/ruleset.xml" ))
   '(flycheck-phpcs-standard (concat (getenv "HOME") "/spacemacs-config/ruleset.xml" ))
  )

  ;; 设置sqlfmt : cnpm install -g sql-formatter
  (setq sqlfmt-executable  "sql-formatter")
  (setq sqlfmt-options  '())




  (add-hook
   'term-mode-hook
   '(lambda()
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
      (define-key evil-insert-state-local-map   (kbd "C-s")  '(lambda() (interactive) ))
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

  ;; (lsp-ui-mode nil)

  (evilmi-load-plugin-rules '(web-mode
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

  (setq undo-tree-auto-save-history nil)


  (setq multi-term-program "/bin/bash")
  (setq multi-term-program "/bin/zsh")

  (set-frame-position (selected-frame) 1920 0)
  (set-frame-width (selected-frame) 91)
  (set-frame-height (selected-frame) 91)
  (recentf-load-list)
  ;; (push '(alpha-background . 20) default-frame-alist)

  )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."

)
