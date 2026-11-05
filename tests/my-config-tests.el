;;; my-config-tests.el --- Personal configuration regression tests -*- lexical-binding: t; -*-

;;; Commentary:
;; Run with the Emacs used for the local Spacemacs installation:
;;   emacs --batch -Q -l tests/my-config-tests.el -f ert-run-tests-batch-and-exit
;; Load the real configuration and dependencies.  The initialization test
;; suppresses server startup and optional external helpers; no PTY is opened.

;;; Code:
(require 'ert)
(require 'cl-lib)
(require 'package)

(defconst my-config-test-root
  (file-name-as-directory
   (expand-file-name ".." (file-name-directory
                           (or load-file-name buffer-file-name))))
  "Root directory of the configuration under test.")

;; Respect an already usable package installation.  Spacemacs normally stores
;; packages below elpa/MAJOR.MINOR/develop instead of the default elpa directory.
(package-initialize)
(unless (locate-library "evil")
  (let ((spacemacs-elpa-directory
         (expand-file-name
          (format "elpa/%d.%d/develop" emacs-major-version emacs-minor-version)
          user-emacs-directory)))
    (when (file-directory-p spacemacs-elpa-directory)
      (setq package-user-dir spacemacs-elpa-directory)
      (package-initialize))))

(add-to-list 'load-path (expand-file-name "core" user-emacs-directory))
(add-to-list 'load-path my-config-test-root)
(setq dotspacemacs-directory my-config-test-root)
(load (expand-file-name "my-config.el" my-config-test-root) nil nil t)

(require 'seq)
(require 'tab-line)
(require 'term)
(require 'multi-term)
(require 'server)
(require 'evil-matchit)
(require 'lsp-mode)
(require 'lsp-volar)

;; These VTerm variables are dynamically bound in the tests.  Requiring VTerm
;; itself could compile its native module, which these tests do not need.
(defvar vterm-mode-map nil)
(defvar vterm-eval-cmds nil)
(defvar vterm-mode-hook nil)
(defvar vterm-keymap-exceptions nil)

(ert-deftest my-config-quote-symbol-at-start ()
  (with-temp-buffer
    (insert "first second")
    (goto-char 7)
    (xcwen/quote-word)
    (should (equal (buffer-string) "first \"second\""))))
(ert-deftest my-config-array-symbol-at-start ()
  (with-temp-buffer
    (insert "first second")
    (goto-char 7)
    (xcwen/php-word-to-array-entry)
    (should (equal (buffer-string) "first \"second\" => $second,"))))
(ert-deftest my-config-defaults-preserve-buffer ()
  (with-temp-buffer
    (setq-local indent-tabs-mode t tab-width 7)
    (insert "unchanged\n")
    (set-buffer-modified-p nil)
    (let ((coding buffer-file-coding-system))
      (xcwen/setup-editing-defaults)
      (should-not (buffer-modified-p))
      (should (eq buffer-file-coding-system coding))
      (should indent-tabs-mode)
      (should (= tab-width 7))
      (should-not (default-value 'indent-tabs-mode))
      (should (= 4 (default-value 'tab-width))))))
(ert-deftest my-config-python-real-arithmetic ()
  (skip-unless (or (executable-find "python3") (executable-find "python")))
  (with-temp-buffer
    (insert "1 + 2")
    (let (seen)
      (cl-letf (((symbol-function 'message)
                 (lambda (format-string &rest args)
                   (setq seen (apply #'format format-string args)))))
        (xcwen/evaluate-line))
      (should (equal seen "exec : 1 + 2\n=>3"))
      (should (equal (buffer-string) "1 + 2")))))
(ert-deftest my-config-python-single-quote-and-shell-text ()
  (skip-unless (or (executable-find "python3") (executable-find "python")))
  (with-temp-buffer
    (insert "\"single' ; $(printf SHELL_WOULD_EXPAND)\"")
    (let (seen)
      (cl-letf (((symbol-function 'message)
                 (lambda (format-string &rest args)
                   (setq seen (apply #'format format-string args)))))
        (xcwen/evaluate-line))
      (should (string-suffix-p "=>single' ; $(printf SHELL_WOULD_EXPAND)" seen)))))
(ert-deftest my-config-completion-previous-preserves-count ()
  (let (seen)
    (cl-letf (((symbol-function 'company--active-p) (lambda () nil))
              ((symbol-function 'evil-complete-previous)
               (lambda (count) (setq seen count))))
      (xcwen/company-previous 3)
      (should (= 3 seen)))))

(ert-deftest my-config-word-commands-reject-empty-buffer ()
  (with-temp-buffer
    (should-error (xcwen/quote-word) :type 'user-error)
    (should-error (xcwen/php-word-to-array-entry) :type 'user-error)
    (should (equal (buffer-string) ""))))

(ert-deftest my-config-php-derived-modes-keep-indentation-setup ()
  (put 'my-config-test-php-mode 'derived-mode-parent 'php-mode)
  (unwind-protect
      (with-temp-buffer
        (setq major-mode 'my-config-test-php-mode)
        (let (eldoc-setting indentation-enabled)
          (cl-letf (((symbol-function 'xcwen/setup-aligned-snippets) #'ignore)
                    ((symbol-function 'my-set-evil-not-insert-local-map) #'ignore)
                    ((symbol-function 'eldoc-mode)
                     (lambda (arg) (setq eldoc-setting arg)))
                    ((symbol-function 'xcwen/php-preserve-block-comment-indentation)
                     (lambda () (setq indentation-enabled t))))
            (xcwen/setup-php-buffer))
          (should (eq eldoc-setting -1))
          (should indentation-enabled)))
    (put 'my-config-test-php-mode 'derived-mode-parent nil)))

(ert-deftest my-config-python-errors-leave-source-unchanged ()
  (skip-unless (or (executable-find "python3") (executable-find "python")))
  (with-temp-buffer
    (insert "1 / 0")
    (should-error (xcwen/evaluate-line) :type 'user-error)
    (should (equal (buffer-string) "1 / 0"))))

(ert-deftest my-config-initialization-preserves-current-buffer ()
  (cl-letf (((symbol-function 'server-running-p) (lambda (&rest _) t))
            ((symbol-function 'server-start)
             (lambda (&rest _) (ert-fail "Unexpected server startup")))
            ((symbol-function 'yas-reload-all) #'ignore)
            ((symbol-function 'xcwen/discover-keyboard-input-device) #'ignore))
    (with-temp-buffer
      (insert "preserve this buffer")
      (setq buffer-file-coding-system 'iso-latin-1-unix)
      (setq-local tab-width 7 indent-tabs-mode t)
      (set-buffer-modified-p nil)
      (my-user-config)
      (my-user-config)
      (should-not (buffer-modified-p))
      (should (equal (buffer-string) "preserve this buffer"))
      (should (eq buffer-file-coding-system 'iso-latin-1-unix))
      (should (= tab-width 7))
      (should indent-tabs-mode)
      (should-not php-mode-warn-if-html-template)
      (should (eq (lookup-key evil-normal-state-map ",L") 'revert-buffer))
      (should (eq (lookup-key minibuffer-local-map (kbd "C-p"))
                  'previous-line-or-history-element))
      (should (= (cl-count #'xcwen/setup-vue-buffer vue-mode-hook) 1)))))

(ert-deftest my-config-vue-bridge-selects-the-matching-project ()
  (let* ((first-root (directory-file-name
                      (file-truename (make-temp-file "my-config-first-" t))))
         (second-root (directory-file-name
                       (file-truename (make-temp-file "my-config-second-" t))))
         (lsp--session (make-lsp-session :folders (list first-root second-root)))
         (client (make-lsp-client :server-id lsp-volar-typescript-server-id))
         (first-ts (make-lsp--workspace :root first-root :client client))
         (second-ts (make-lsp--workspace :root second-root :client client))
         (volar (make-lsp--workspace :root second-root))
         forwarded)
    (unwind-protect
        (progn
          (puthash first-root (list first-ts)
                   (lsp-session-folder->servers lsp--session))
          (puthash second-root (list second-ts)
                   (lsp-session-folder->servers lsp--session))
          (cl-letf (((symbol-function 'xcwen/vue--forward-tsserver-request)
                     (lambda (&rest args) (setq forwarded args))))
            (xcwen/vue-tsserver-request-handler volar [[42 "quickinfo" nil]]))
          (should (eq (car forwarded) second-ts))
          (should (equal (cddr forwarded)
                         (list 42 "quickinfo" nil xcwen/vue-tsserver-project-retries))))
      (delete-directory first-root)
      (delete-directory second-root))))

(ert-deftest my-config-vue-bridge-answers-when-typescript-is-unavailable ()
  (let ((lsp--session (make-lsp-session))
        (volar (make-lsp--workspace :root temporary-file-directory))
        reply)
    (cl-letf (((symbol-function 'lsp--error) #'ignore)
              ((symbol-function 'lsp-volar--send-notify)
               (lambda (&rest args) (setq reply args))))
      (xcwen/vue-tsserver-request-handler volar [[42 "quickinfo" nil]]))
    (should (equal reply (list volar "tsserver/response" [[42 nil]])))))

(defmacro my-config-test-with-flycheck-state (&rest body)
  `(let ((xcwen/flycheck-pending-message nil)
         (xcwen/flycheck-last-message nil)
         (minibuffer-exit-hook nil)
         (active nil)
         (depth 0)
         (echo-text nil)
         (messages nil))
     (cl-letf (((symbol-function 'active-minibuffer-window) (lambda () active))
               ((symbol-function 'minibuffer-depth) (lambda () depth))
               ((symbol-function 'flycheck-help-echo-all-error-messages)
                (lambda (errors) (car errors)))
               ((symbol-function 'current-message) (lambda () echo-text))
               ((symbol-function 'message)
                (lambda (format-string &rest args)
                  (setq echo-text (and format-string
                                       (apply #'format format-string args)))
                  (push echo-text messages)
                  echo-text)))
       ,@body)))

(ert-deftest my-config-php-jump-without-layer-and-no-duplicate ()
  (should (boundp 'spacemacs-jump-handlers-php-mode))
  (let* ((handlers '(first ac-php-find-symbol-at-point last
                          (ac-php-find-symbol-at-point :async nil)))
         (result (xcwen/ac-php-stop-jump-fallback handlers)))
    (should (equal result '((ac-php-find-symbol-at-point :async t) first last)))
    (should (equal result (xcwen/ac-php-stop-jump-fallback result)))))

(ert-deftest my-config-flycheck-queues-latest-without-popup ()
  (my-config-test-with-flycheck-state
   (setq active t)
   (xcwen/flycheck-display-error-messages '("old"))
   (xcwen/flycheck-display-error-messages '("latest"))
   (should (equal xcwen/flycheck-pending-message "latest"))
   (should (null messages))
   (should (equal minibuffer-exit-hook
                  '(xcwen/flycheck-display-pending-message)))))

(ert-deftest my-config-flycheck-direct-display-cancels-old-pending ()
  (my-config-test-with-flycheck-state
   (setq active t)
   (xcwen/flycheck-display-error-messages '("old"))
   (setq active nil)
   (xcwen/flycheck-display-error-messages '("new"))
   (xcwen/flycheck-display-pending-message)
   (should (equal messages '("new")))
   (should (null minibuffer-exit-hook))
   (should (null xcwen/flycheck-pending-message))))

(ert-deftest my-config-flycheck-recursive-minibuffer-waits-for-outer-exit ()
  (my-config-test-with-flycheck-state
   (setq active t depth 2)
   (xcwen/flycheck-display-error-messages '("diagnostic"))
   (xcwen/flycheck-display-pending-message)
   (should (null messages))
   (should minibuffer-exit-hook)
   (should xcwen/flycheck-pending-message)
   (setq depth 1)
   (xcwen/flycheck-display-pending-message)
   (should (equal messages '("diagnostic")))
   (should (null xcwen/flycheck-pending-message))
   (should (null minibuffer-exit-hook))))

(ert-deftest my-config-flycheck-clear-cancels-pending ()
  (my-config-test-with-flycheck-state
   (setq active t)
   (xcwen/flycheck-display-error-messages '("stale"))
   (xcwen/flycheck-clear-displayed-errors)
   (xcwen/flycheck-display-pending-message)
   (should (null messages))
   (should (null minibuffer-exit-hook))))

(ert-deftest my-config-flycheck-nil-errors-clears-owned-echo-message ()
  (my-config-test-with-flycheck-state
   (xcwen/flycheck-display-error-messages '("diagnostic"))
   (xcwen/flycheck-display-error-messages nil)
   (should (null echo-text))
   (should (null xcwen/flycheck-last-message))))

(ert-deftest my-config-flycheck-clear-preserves-unrelated-echo-message ()
  (my-config-test-with-flycheck-state
   (xcwen/flycheck-display-error-messages '("diagnostic"))
   (setq echo-text "unrelated command")
   (xcwen/flycheck-clear-displayed-errors)
   (should (equal echo-text "unrelated command"))
   (should (equal messages '("diagnostic")))))

(defmacro my-config-test-with-terminal-buffers (&rest body)
  `(let ((first (generate-new-buffer " *terminal-first*"))
         (second (generate-new-buffer " *terminal-second*"))
         (third (generate-new-buffer " *terminal-third*"))
         (my/vterm-tab-order nil))
     (unwind-protect
         (progn
           (dolist (buffer (list first second third))
             (with-current-buffer buffer (setq major-mode 'vterm-mode)))
           ,@body)
       (dolist (buffer (list first second third))
         (when (buffer-live-p buffer) (kill-buffer buffer))))))

(ert-deftest my-config-terminal-tab-order-survives-buffer-recency-and-close ()
  (my-config-test-with-terminal-buffers
   (setq my/vterm-tab-order (list second first))
   (should (equal (my/vterm-tab-buffers) (list second first third)))
   (kill-buffer second)
   (should (equal (my/vterm-tab-buffers) (list first third)))))

(ert-deftest my-config-terminal-tab-moves-in-both-directions ()
  (my-config-test-with-terminal-buffers
   (setq my/vterm-tab-order (list first second third))
   (my/vterm-move-tab first third)
   (should (equal my/vterm-tab-order (list second third first)))
   (my/vterm-move-tab first second)
   (should (equal my/vterm-tab-order (list first second third)))))

(ert-deftest my-config-terminal-label-uses-directory-and-validates-ssh-label ()
  (with-temp-buffer
    (setq major-mode 'vterm-mode
          default-directory "/tmp/project/")
    (should (equal (substring-no-properties (my/vterm-tab-name (current-buffer))) "project"))
    (my/vterm-set-ssh-label "ssh-my_server.example")
    (should (equal (substring-no-properties (my/vterm-tab-name (current-buffer))) "ssh-my_server.example"))
    (my/vterm-set-ssh-label "bad label")
    (should (equal (substring-no-properties (my/vterm-tab-name (current-buffer))) "project"))
    (setq default-directory "/")
    (should (equal (substring-no-properties (my/vterm-tab-name (current-buffer))) "/"))))

(ert-deftest my-config-terminal-setup-registers-hooks-once ()
  (let ((vterm-mode-hook '(my/vterm-enable-tabs))
        (term-mode-hook nil)
        (my/vterm-tab-order nil))
    (xcwen/setup-terminals)
    (xcwen/setup-terminals)
    (should (equal vterm-mode-hook '(my/vterm-configure-buffer)))
    (should (equal term-mode-hook '(my/term-configure-buffer)))))

(ert-deftest my-config-terminal-vterm-first-load-keeps-control-c-prefix ()
  ;; Exercise the real package's initial keymap construction in a fresh Emacs.
  ;; Reusing a loaded map (or a sparse mock) misses prefix conflicts on load.
  (let* ((emacs (expand-file-name invocation-name invocation-directory))
         (form
          `(progn
             (setq load-path ',load-path
                   dotspacemacs-directory ,my-config-test-root)
             (load ,(expand-file-name "my-config.el" my-config-test-root) nil t t)
             (xcwen/setup-terminals)
             ;; Prevent any native module build or interactive prompt.
             (unless (require 'vterm-module nil t)
               (error "VTerm native module is required for this load test"))
             (require 'multi-vterm)
             (cl-assert (keymapp (lookup-key vterm-mode-map (kbd "C-c"))))
             (cl-assert (eq (lookup-key vterm-mode-map (kbd "C-c C-y"))
                            'vterm--self-insert)))))
    (with-temp-buffer
      (let ((status (call-process emacs nil t nil "--batch" "-Q"
                                  "--eval" (prin1-to-string form))))
        (unless (eq status 0)
          (ert-fail (buffer-string)))))))

(ert-deftest my-config-terminal-vterm-configuration-preserves-bindings-and-is-repeatable ()
  (with-temp-buffer
    (setq major-mode 'vterm-mode)
    (let ((evil-insert-state-local-map (make-sparse-keymap))
          (vterm-mode-map (make-sparse-keymap))
          (vterm-eval-cmds nil))
      (cl-letf (((symbol-function 'xcwen/vterm-bind-reliable-yank)
                 (lambda ()
                   (dolist (key '("C-y" "C-v" "s-v"))
                     (define-key evil-insert-state-local-map (kbd key) 'xcwen/vterm-yank)))))
        (my/vterm-configure-buffer)
        (my/vterm-configure-buffer)
        (should (eq (lookup-key evil-insert-state-local-map (kbd "C-v")) 'xcwen/vterm-yank))
        (should (eq (lookup-key evil-insert-state-local-map (kbd "C-c")) 'copy-region-or-whole-line))
        (should (eq (lookup-key evil-insert-state-local-map (kbd "C-S-c")) 'vterm-send-C-c))
        (should (eq (lookup-key evil-insert-state-local-map (kbd "<escape>")) 'vterm--self-insert))
        (should (eq (lookup-key evil-insert-state-local-map (kbd "C-S-h")) 'multi-vterm-prev))
        (should (eq (lookup-key vterm-mode-map (kbd "M-x")) 'helm-M-x))
        (should (equal vterm-eval-cmds '(("my-vterm-ssh-label" my/vterm-set-ssh-label))))
        (should (eq tab-line-tabs-function 'my/vterm-tab-buffers))
        (should tab-line-mode)))))

(ert-deftest my-config-terminal-multi-term-first-buffer-uses-configured-keys ()
  (let ((term-mode-hook nil)
        (vterm-mode-hook nil)
        (my/vterm-tab-order nil)
        (term-raw-map (copy-keymap term-raw-map))
        (evil-insert-state-local-map (make-sparse-keymap)))
    (xcwen/setup-terminals)
    ;; Reproduce multi-term-internal's hook order, without starting a process.
    (add-hook 'term-mode-hook #'multi-term-keystroke-setup)
    (with-temp-buffer
      (term-mode)
      (should (eq (lookup-key term-raw-map (kbd "C-6")) 'my/term-send-control-caret))
      (should (eq (lookup-key term-raw-map (kbd "C-S-t")) 'multi-term))
      (should (eq (lookup-key term-raw-map (kbd "M-x")) 'helm-M-x))
      (should (eq (lookup-key evil-insert-state-local-map (kbd "C-y")) 'term-paste)))))

(provide 'my-config-tests)

;;; my-config-tests.el ends here
