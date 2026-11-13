;;; my-config.el --- Personal Spacemacs editing and terminal settings -*- lexical-binding: nil; -*-

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

;;; Commentary:
;; Loaded by `dotspacemacs/user-config'; `my-user-config' applies the settings.
;; Keep dynamic binding for the temporary settings used by the paste helpers.

;;; Code:
(require 'cl-lib)
(require 'subr-x)
(require 'core-dotspacemacs)
(add-to-list 'load-path dotspacemacs-directory)

(defun xcwen/spacemacs-file (file)
  "Return FILE expanded under `dotspacemacs-directory'."
  (expand-file-name file dotspacemacs-directory))

(require 'xcwen-misc)
(require 'xcwen-project-jump)
(require 'init-syntax-table)
(require 'init-sqruff)
(require 'core-jump)

(autoload 'php-ts-mode "php-ts-mode" nil t)
(autoload 'helm-projectile-grep "helm-projectile" nil t)
(defvar my-keyboard-input-dev ""
  "Input device discovered by the optional keyboard helper script.")

(defun xcwen/ac-php-stop-jump-fallback (handlers)
  "Make ac-php the final jump attempt in HANDLERS."
  (cons '(ac-php-find-symbol-at-point :async t)
        (cl-remove-if
         (lambda (handler)
           (eq (if (consp handler) (car handler) handler)
               'ac-php-find-symbol-at-point))
         handlers)))

(defvar spacemacs-jump-handlers-php-mode nil
  "PHP jump handlers, also available when the PHP layer is disabled.")

(setq spacemacs-jump-handlers-php-mode
      (xcwen/ac-php-stop-jump-fallback
       spacemacs-jump-handlers-php-mode))

(with-eval-after-load 'php-ts-mode
  (spacemacs|define-jump-handlers php-ts-mode)
  (setq spacemacs-jump-handlers-php-ts-mode
        (xcwen/ac-php-stop-jump-fallback
         spacemacs-jump-handlers-php-ts-mode)))

(defvar xcwen/flycheck-pending-message nil
  "Flycheck message waiting for the active minibuffer to exit.")

(defvar xcwen/flycheck-last-message nil
  "Last Flycheck message displayed directly in the echo area.")

(defun xcwen/flycheck-clear-pending-message ()
  "Cancel any Flycheck message waiting for the minibuffer to exit."
  (setq xcwen/flycheck-pending-message nil)
  (remove-hook 'minibuffer-exit-hook
               #'xcwen/flycheck-display-pending-message))

(defun xcwen/flycheck-clear-displayed-errors ()
  "Cancel pending diagnostics and clear the last Flycheck echo message."
  (xcwen/flycheck-clear-pending-message)
  ;; Leave unrelated command messages and minibuffer prompts alone.
  (when (and xcwen/flycheck-last-message
             (equal (current-message) xcwen/flycheck-last-message))
    (message nil))
  (setq xcwen/flycheck-last-message nil))

(defun xcwen/flycheck-display-pending-message ()
  "Display the Flycheck message saved while a minibuffer was active."
  ;; The exit hook runs before the minibuffer being exited is deactivated.
  ;; A recursive minibuffer must leave the message for the outermost exit.
  (unless (> (minibuffer-depth) 1)
    (let ((text xcwen/flycheck-pending-message))
      (xcwen/flycheck-clear-pending-message)
      (when text
        (setq xcwen/flycheck-last-message (message "%s" text))))))

(defun xcwen/flycheck-display-error-messages (errors)
  "Display Flycheck ERRORS directly in the echo area.

When called from Helm `M-x', wait until its minibuffer exits so the
diagnostic is not hidden by the command picker."
  (if (null errors)
      (xcwen/flycheck-clear-displayed-errors)
    (let ((text (flycheck-help-echo-all-error-messages errors)))
      (if (active-minibuffer-window)
          (progn
            (setq xcwen/flycheck-pending-message text)
            (add-hook 'minibuffer-exit-hook
                      #'xcwen/flycheck-display-pending-message))
        (xcwen/flycheck-clear-pending-message)
        (setq xcwen/flycheck-last-message (message "%s" text))))))

(setq flycheck-display-errors-function
      #'xcwen/flycheck-display-error-messages
      flycheck-clear-displayed-errors-function
      #'xcwen/flycheck-clear-displayed-errors)

(defun xcwen/project-action ()
  "Check SQL, refresh PHP builder types, or restart the current project."
  (interactive)
  (cond
   ((derived-mode-p 'sql-mode) (xcwen/sql-check-with-mysql))
   ((check-in-php-mode) (xcwen/php-update-builder-item-types-current-buffer))
   (t (restart-project))))

(defun xcwen/project-search ()
  "Search PHP application sources or use the current project's search."
  (interactive)
  (if (check-in-php-mode)
      (helm-projectile-grep
       (expand-file-name "src/app" (projectile-project-root)))
    (spacemacs/helm-project-smart-do-search)))

(defun xcwen/show-diagnostic-or-documentation ()
  "Show the error at point, a PHP tip, or LSP documentation."
  (interactive)
  (cond
   ((and (bound-and-true-p flycheck-mode)
         (flycheck-overlay-errors-at (point)))
    (flycheck-display-error-at-point))
   ((check-in-php-mode)
    (when (fboundp 'ac-php-show-tip)
      (ac-php-show-tip)))
   ((fboundp 'lsp-ui-doc-show)
    (lsp-ui-doc-show))))

(defvar xcwen/ac-php-scrollable-tip nil
  "Non-nil while displaying an explicitly requested PHP tip.")

(defun xcwen/ac-php-with-scrollable-tip (function &rest args)
  "Call FUNCTION with ARGS and enable scrolling for its PHP tip."
  (let ((xcwen/ac-php-scrollable-tip t))
    (apply function args)))

(defvar xcwen/php-tip-keymap
  (let ((map (make-sparse-keymap)))
    (dolist (key '("j" "C-n" "<down>" "<wheel-down>" "<mouse-5>"))
      (define-key map (kbd key) 'line-down))
    (dolist (key '("k" "C-p" "<up>" "<wheel-up>" "<mouse-4>"))
      (define-key map (kbd key) 'line-up))
    (dolist (key '("C-f" "C-v" "<next>"))
      (define-key map (kbd key) 'page-down))
    (dolist (key '("C-b" "M-v" "<prior>"))
      (define-key map (kbd key) 'page-up))
    (dolist (key '("q" "<escape>" "RET" "C-g"))
      (define-key map (kbd key) 'close))
    map)
  "Keys active while an explicit PHP documentation tip is visible.")

(defun xcwen/popup-tip-scrollable (function text &rest args)
  "Let FUNCTION display TEXT with ARGS and scroll explicit PHP tips."
  (if (or (not xcwen/ac-php-scrollable-tip) (plist-get args :nowait))
      (apply function text args)
    (let ((tip (apply function text (plist-put (copy-sequence args) :nowait t))))
      (unwind-protect
          (when (and tip (popup-live-p tip))
            (catch 'done
              (while (popup-live-p tip)
                (let* ((key (popup-menu-read-key-sequence
                             xcwen/php-tip-keymap
                             "PHP tip: j/k scroll, C-f/C-b page, q close"))
                       (action (lookup-key xcwen/php-tip-keymap key))
                       (page (max 1 (1- (popup-height tip)))))
                  (pcase action
                    ((or 'line-down 'page-down)
                     ;; popup-scroll-down assumes the content exceeds the height.
                     (when (> (length (popup-list tip)) (popup-height tip))
                       (popup-scroll-down tip (if (eq action 'page-down) page 1))))
                    ((or 'line-up 'page-up)
                     (popup-scroll-up tip (if (eq action 'page-up) page 1)))
                    ('close (throw 'done t))
                    (_ (setq unread-command-events
                             (append (listify-key-sequence key)
                                     unread-command-events))
                       (throw 'done t)))))))
        (when tip (popup-delete tip))))))

(with-eval-after-load 'popup
  (advice-add 'popup-tip :around #'xcwen/popup-tip-scrollable))
(with-eval-after-load 'ac-php-core
  (advice-add 'ac-php-show-tip :around #'xcwen/ac-php-with-scrollable-tip))

(defun xcwen/quote-word ()
  "Quote the symbol at point, or split a PHP string for concatenation."
  (interactive "*")
  (if (and (check-in-php-mode)
           (fboundp 'ac-php--in-string-or-comment-p)
           (ac-php--in-string-or-comment-p))
      (progn
        (insert "\" . \"")
        (backward-char 4))
    (let ((bounds (bounds-of-thing-at-point 'symbol)))
      (unless bounds
        (user-error "No symbol at point"))
      (save-excursion
        (goto-char (cdr bounds))
        (insert "\"")
        (goto-char (car bounds))
        (insert "\"")))))

(defun xcwen/php-word-to-array-entry ()
  "Turn the symbol at point into a PHP array entry."
  (interactive "*")
  (let ((bounds (bounds-of-thing-at-point 'symbol)))
    (unless bounds
      (user-error "No symbol at point"))
    (let ((word (buffer-substring-no-properties (car bounds) (cdr bounds))))
      (save-excursion
        (goto-char (cdr bounds))
        (insert "\" => $" word ",")
        (goto-char (car bounds))
        (insert "\"")))))

(defun xcwen/php-jump-table ()
  "Jump to the table definition from a PHP buffer."
  (interactive)
  (when (and (check-in-php-mode) (fboundp 'my-jump-table-sql))
    (my-jump-table-sql)))

(defun xcwen/php-remake-tags ()
  "Rebuild ac-php tags in a PHP buffer."
  (interactive)
  (when (and (check-in-php-mode) (fboundp 'ac-php-remake-tags))
    (ac-php-remake-tags)))

(defun xcwen/php-generate-definition ()
  "Generate a local variable definition in a PHP buffer."
  (interactive)
  (when (and (check-in-php-mode) (fboundp 'ac-php-gen-def))
    (ac-php-gen-def)))

(defun set-main-key ()
  "Install the custom comma-prefix commands in Evil's main states."
  (define-key evil-motion-state-map "," nil)
  (dolist (binding
           '(("w" . save-buffer)
             ("u" . upper-or-lower-whole-word)
             ("L" . revert-buffer)
             ("a" . xcwen-jump-related)
             ("A" . xcwen-jump-proto)
             ("e" . cleanup-and-goto-error)
             ("d" . manggo-translate-region)
             ("c" . lsp-execute-code-action)
             ("o" . other-window)
             ("m" . xcwen/project-action)
             ("/" . xcwen/project-search)
             ("i" . xcwen/show-diagnostic-or-documentation)
             ("\"" . xcwen/quote-word)
             (":" . xcwen/php-word-to-array-entry)
             ("D" . xcwen/php-jump-table)
             ("r" . xcwen/php-remake-tags)
             ("f" . xcwen/php-generate-definition)))
    (set-evil-main-state-key (car binding) (cdr binding)))
  (set-evil-all-state-key (kbd "C-S-j") #'switch-file-term))

(with-eval-after-load 'cc-mode
  (set-evil-main-state-key-on-mode java-mode-map "m" #'restart-project)
  (set-evil-main-state-key-on-mode java-mode-map "t" #'maven-test-method))

(defun xcwen/setup-snippet-key ()
  "Use TAB to expand snippets in the current Evil buffer."
  (my-set-evil-local-map "<tab>" #'yas-expand-for-vim))

(defun xcwen/setup-aligned-snippets ()
  "Enable snippet expansion and alignment in the current buffer."
  (xcwen/setup-snippet-key)
  (my-set-evil-not-insert-local-map "=" #'align-eq))

(defun xcwen/setup-php-buffer ()
  "Configure PHP snippets, jumps, and block comment indentation."
  (xcwen/setup-aligned-snippets)
  (my-set-evil-not-insert-local-map "g\C-]" #'my-jump-merber-class)
  (when (derived-mode-p 'php-mode)
    (eldoc-mode -1)
    (xcwen/php-preserve-block-comment-indentation)))

(defun xcwen/setup-vue-buffer ()
  "Configure Vue completion and keep live helpers quiet during paste."
  (xcwen/setup-aligned-snippets)
  (setq-local company-backends '(company-capf))
  (setq-local flycheck-check-syntax-automatically '(save mode-enabled))
  (setq-local lsp-debounce-full-sync-notifications t)
  (setq-local lsp-enable-on-type-formatting nil)
  (setq-local lsp-enable-indentation nil)
  (setq-local lsp-enable-symbol-highlighting nil)
  (dolist (key '("C-v" "C-y"))
    (define-key evil-insert-state-local-map (kbd key) #'xcwen/vue-yank-fast))
  (dolist (map (list evil-normal-state-local-map evil-visual-state-local-map))
    (define-key map "p" #'xcwen/vue-evil-paste-after-fast)
    (define-key map "P" #'xcwen/vue-evil-paste-before-fast)))

(defun xcwen/setup-org-buffer ()
  "Use the text object and navigation bindings from evil-org."
  (when (require 'evil-org nil t)
    (setq evil-org-key-theme '(textobjects navigation))
    (evil-org-set-key-theme evil-org-key-theme)))

(defun xcwen/setup-java-buffer ()
  "Configure Java snippets and the jump-back key."
  (xcwen/setup-snippet-key)
  (my-set-evil-local-map "\C-t" #'xref-pop-marker-stack))

(defun xcwen/setup-checked-buffer ()
  "Enable diagnostics, completion, and the jump-back key."
  (flycheck-mode 1)
  (company-mode 1)
  (my-set-evil-local-map "\C-t" #'xref-pop-marker-stack))

(defun xcwen/setup-mode-hooks ()
  "Install named hooks for the configured programming modes."
  (dolist (hook '(html-mode-hook vue-mode-hook))
    (add-hook hook #'zencoding-mode))
  (dolist (hook '(go-mode-hook web-mode-hook lua-mode-hook rust-mode-hook))
    (add-hook hook #'xcwen/setup-snippet-key))
  (add-hook 'python-mode-hook #'xcwen/setup-aligned-snippets)
  (add-hook 'vue-mode-hook #'xcwen/setup-vue-buffer)
  (add-hook 'org-mode-hook #'xcwen/setup-org-buffer)
  (add-hook 'php-mode-hook #'xcwen/setup-php-buffer)
  (add-hook 'php-ts-mode-hook #'xcwen/setup-php-buffer)
  (add-hook 'java-mode-hook #'xcwen/setup-java-buffer)
  ;; Keep the existing choice to edit JavaScript and TypeScript in vue-mode.
  (add-hook 'typescript-mode-hook #'vue-mode)
  (add-hook 'js-mode-hook #'vue-mode)
  (dolist (hook '(sh-mode-hook json-mode-hook emacs-lisp-mode-hook))
    (add-hook hook #'xcwen/setup-checked-buffer)))

(defun xcwen/evaluate-line (&optional prefix)
  "Evaluate Lisp or SQL in its mode, otherwise a Python expression.
Pass PREFIX through to `eval-last-sexp' in Emacs Lisp buffers."
  (interactive "P")
  (cond
   ((derived-mode-p 'emacs-lisp-mode)
    (eval-last-sexp prefix))
   ((derived-mode-p 'sql-mode)
    (my/send-sql-to-current-vterm))
   (t
    (let ((python (or (executable-find "python3") (executable-find "python")))
          (expression (buffer-substring-no-properties
                       (line-beginning-position) (line-end-position))))
      (unless python
        (user-error "Cannot find python3 or python"))
      (with-temp-buffer
        (insert expression)
        (let ((status (call-process-region
                       (point-min) (point-max) python t t nil
                       "-c" "import sys; print(eval(sys.stdin.read()))")))
          (unless (eq status 0)
            (user-error "Python: %s" (string-trim (buffer-string))))
          (message "exec : %s\n=>%s" expression (string-trim (buffer-string)))))))))

(defun xcwen/normal-state-escape ()
  "Send ESC in term-mode, otherwise leave transient editing UI."
  (interactive)
  (if (derived-mode-p 'term-mode)
      (term-send-esc)
    (fcitx-inactivate-input-method)
    (evil-force-normal-state)
    (when (fboundp 'lsp-ui-doc-hide)
      (lsp-ui-doc-hide))))

(defun xcwen/insert-state-escape ()
  "Send ESC in term-mode, otherwise return to Evil normal state."
  (interactive)
  (if (derived-mode-p 'term-mode)
      (term-send-esc)
    (fcitx-inactivate-input-method)
    (evil-normal-state)))

(defun xcwen/previous-terminal-or-unindent ()
  "Select the previous VTerm or unindent the current line."
  (interactive)
  (if (derived-mode-p 'vterm-mode)
      (multi-vterm-prev)
    (remove-line-begin-space)))

(defun xcwen/next-terminal-or-indent ()
  "Select the next VTerm or indent the current line."
  (interactive)
  (if (derived-mode-p 'vterm-mode)
      (multi-vterm-next)
    (insert-line-begin-space)))

(defun xcwen/isearch-yank-trimmed ()
  "Yank trimmed kill-ring text into incremental search."
  (interactive)
  (isearch-yank-string (string-trim (current-kill 0))))

(defun xcwen/search-yank-trimmed ()
  "Insert trimmed kill-ring text in Evil search."
  (interactive)
  (insert (string-trim (current-kill 0))))

(defun xcwen/company-previous (&optional count)
  "Select the previous Company candidate, or complete the previous word.
Move by COUNT candidates when Company is active."
  (interactive "p")
  (if (company--active-p)
      (company-select-previous count)
    (evil-complete-previous count)))

(defun xcwen/company-next (&optional count)
  "Select the next Company candidate, or complete the next word.
Move by COUNT candidates when Company is active."
  (interactive "p")
  (if (company--active-p)
      (company-select-next count)
    (evil-complete-next count)))

(defmacro xcwen/vue-with-fast-paste (&rest body)
  "Run BODY with expensive live helpers quieted for Vue paste."
  `(let ((gc-cons-threshold most-positive-fixnum)
         (gc-cons-percentage 0.6)
         (inhibit-redisplay t)
         (inhibit-message t)
         (electric-indent-inhibit t)
         (flycheck-check-syntax-automatically nil)
         (company-idle-delay nil)
         (lsp-debounce-full-sync-notifications t)
         (lsp-enable-on-type-formatting nil)
         (lsp-enable-symbol-highlighting nil)
         (lsp-enable-indentation nil))
     (when (fboundp 'company-abort)
       (company-abort))
     ,@body))

(defun xcwen/vue-yank-fast (&optional arg)
  "Yank in `vue-mode' without triggering expensive live helpers."
  (interactive "*P")
  (xcwen/vue-with-fast-paste
   (yank arg)))

(defun xcwen/vue-evil-paste-after-fast (count &optional register)
  "Paste after point in `vue-mode' without triggering expensive live helpers."
  (interactive "*P")
  (setq this-command 'evil-paste-after)
  (xcwen/vue-with-fast-paste
   (evil-paste-after count (or register evil-this-register))))

(defun xcwen/vue-evil-paste-before-fast (count &optional register)
  "Paste before point in `vue-mode' without triggering expensive live helpers."
  (interactive "*P")
  (setq this-command 'evil-paste-before)
  (xcwen/vue-with-fast-paste
   (evil-paste-before count (or register evil-this-register))))

(defconst xcwen/vue-tsserver-project-retries 8
  "Number of times to retry Volar's project lookup while tsserver starts.")

(defun xcwen/vue--tsserver-response (volar-workspace id response)
  "Forward tsserver RESPONSE for ID to VOLAR-WORKSPACE."
  (lsp-volar--send-notify
   volar-workspace "tsserver/response"
   (vector (vector id (lsp-get response :body)))))

(defun xcwen/vue--tsserver-error-message (error-response)
  "Extract a message string from ERROR-RESPONSE."
  (or (and (hash-table-p error-response)
           (or (gethash "message" error-response)
               (gethash :message error-response)))
      (and (listp error-response)
           (or (plist-get error-response :message)
               (alist-get 'message error-response)
               (alist-get "message" error-response nil nil #'equal)))
      (format "%s" error-response)))

(defun xcwen/vue--tsserver-error
    (ts-ls-workspace volar-workspace id command payload retries error-response)
  "Handle a forwarded tsserver ERROR-RESPONSE, retrying transient project races."
  (if (and (> retries 0)
           (string-match-p
            "No Project"
            (xcwen/vue--tsserver-error-message error-response)))
      (run-at-time 0.25 nil #'xcwen/vue--forward-tsserver-request
                   ts-ls-workspace volar-workspace id command payload
                   (1- retries))
    ;; Volar waits on every request ID.  Always answer so one tsserver error
    ;; cannot leave the Vue language server permanently blocked.
    (lsp--warn "tsserver/request failed: %S" error-response)
    (lsp-volar--send-notify
     volar-workspace "tsserver/response" (vector (vector id nil)))))

(defun xcwen/vue--forward-tsserver-request
    (ts-ls-workspace volar-workspace id command payload retries)
  "Forward one Volar request to TS-LS-WORKSPACE, with RETRIES remaining."
  (with-lsp-workspace ts-ls-workspace
    (lsp-request-async
     "workspace/executeCommand"
     (list :command "typescript.tsserverRequest"
           :arguments (vector command payload))
     (apply-partially #'xcwen/vue--tsserver-response volar-workspace id)
     :error-handler
     (apply-partially #'xcwen/vue--tsserver-error
                      ts-ls-workspace volar-workspace id command payload retries))))

(defun xcwen/vue-tsserver-request-handler (volar-workspace params)
  "Forward Volar PARAMS through the TypeScript LSP bridge."
  (let* ((request (aref params 0))
         (ts-ls-workspace
          (lsp-find-workspace lsp-volar-typescript-server-id
                              (lsp--workspace-root volar-workspace))))
    (if ts-ls-workspace
        (xcwen/vue--forward-tsserver-request
         ts-ls-workspace volar-workspace
         (aref request 0) (aref request 1) (aref request 2)
         xcwen/vue-tsserver-project-retries)
      (lsp--error
       "[lsp-volar] Could not find `%s`; Vue TypeScript features are unavailable"
       lsp-volar-typescript-server-id)
      ;; Reply even when this project's TypeScript server has not started yet.
      (lsp-volar--send-notify
       volar-workspace "tsserver/response" (vector (vector (aref request 0) nil))))))

(defconst xcwen/vue-typescript-compat-sdk
  (let ((compat (expand-file-name
                 ".cache/lsp/npm/@typescript/typescript6/lib/node_modules/@typescript/typescript6/lib"
                 user-emacs-directory)))
    (if (file-readable-p (expand-file-name "typescript.js" compat))
        compat
      (expand-file-name
       ".cache/lsp/npm/typescript/lib/node_modules/typescript/lib"
       user-emacs-directory)))
  "TypeScript compatibility SDK used by the Vue language server.")

(defconst xcwen/vue-typescript-compat-tsserver
  (let ((legacy (expand-file-name
                 "../node_modules/@typescript/old/lib/tsserver.js"
                 xcwen/vue-typescript-compat-sdk)))
    (if (file-readable-p legacy)
        legacy
      (expand-file-name "tsserver.js" xcwen/vue-typescript-compat-sdk)))
  "tsserver executable paired with the Vue compatibility SDK.")

(defun xcwen/vue-language-server-command ()
  "Start Vue Language Server with the TypeScript compatibility SDK."
  (list (lsp-package-path 'volar-language-server)
        "--stdio"
        (concat "--tsdk=" xcwen/vue-typescript-compat-sdk)))

(defun xcwen/setup-lsp ()
  "Configure LSP preferences and the Vue TypeScript bridge."
  ;; Disable automatic documentation popups; comma-i still shows them manually.
  (setq lsp-ui-doc-delay 1
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse nil
        lsp-eldoc-enable-hover nil
        lsp-ui-sideline-delay 10000
        lsp-enable-symbol-highlighting t
        lsp-enable-xref nil
        lsp-enable-indentation t
        lsp-auto-execute-action nil
        lsp-debounce-full-sync-notifications t
        lsp-enable-file-watchers nil
        lsp-enable-folding nil
        lsp-flycheck-enable-unnecessary-info nil)
  (let ((lombok-jar (xcwen/spacemacs-file "bin/lombok-1.18.24.jar")))
    (setq lsp-java-vmargs
          (append
           '("-noverify" "-Xmx1G" "-XX:+UseG1GC" "-XX:+UseStringDeduplication")
           (when (file-readable-p lombok-jar)
             (list (concat "-javaagent:" lombok-jar)
                   (concat "-Xbootclasspath/a:" lombok-jar))))))
  (with-eval-after-load 'lsp-mode
    (let ((brainrot-lsp (expand-file-name "~/brainrot-lsp/brainrot-lsp")))
      (when (file-executable-p brainrot-lsp)
        (lsp-register-client
         (make-lsp-client
          :new-connection (lsp-stdio-connection (list brainrot-lsp))
          :activation-fn (lambda (filename _mode)
                           (and filename
                                (string-match-p "\\.\\(?:txt\\|md\\)\\'" filename)))
          :priority -1
          :server-id 'brainrot)))))
  (with-eval-after-load 'lsp-volar
    ;; Both sides of the bridge must use the same TypeScript compiler.
    (when (file-exists-p xcwen/vue-typescript-compat-tsserver)
      (lsp-dependency
       'typescript `(:system ,xcwen/vue-typescript-compat-tsserver)))
    (when-let* ((client (gethash 'vue-semantic-server lsp-clients)))
      (puthash "tsserver/request" #'xcwen/vue-tsserver-request-handler
               (lsp--client-notification-handlers client))
      ;; Expand the struct setter after lsp-mode has defined lsp--client.
      (let ((connection
             (lsp-stdio-connection #'xcwen/vue-language-server-command)))
        (eval (list 'setf
                    (list 'lsp--client-new-connection (list 'quote client))
                    (list 'quote connection)))))))

(defun xcwen/setup-editing-defaults ()
  "Set defaults for new buffers without changing the current file."
  (setq-default indent-tabs-mode nil
                tab-width 4)
  ;; Remove the previous unanchored rules when reloading this configuration.
  (dolist (regexp '("\\.php" "\\.go"))
    (setq file-coding-system-alist
          (delete (cons regexp 'utf-8) file-coding-system-alist)))
  (dolist (regexp '("\\.php\\'" "\\.go\\'"))
    (add-to-list 'file-coding-system-alist (cons regexp 'utf-8)))
  (setq left-fringe-width 48
        create-lockfiles nil))

(defun xcwen/discover-keyboard-input-device ()
  "Read the input device from the optional local helper script."
  (let ((script (expand-file-name "~/desktop/key_send/get_kbd_eventid.sh")))
    (when (file-executable-p script)
      (with-temp-buffer
        (when (eq 0 (call-process script nil t nil))
          (setq my-keyboard-input-dev (string-trim (buffer-string))))))))

(defun xcwen/save-and-switch-to-terminal ()
  "Save the current buffer and return to the last terminal."
  (interactive)
  (save-buffer)
  (multi-term-goto-last-term))

(defun xcwen/setup-keybindings ()
  "Install global editing, completion, and search bindings."
  (set-main-key)
  (dolist (binding
           '(("<f8>" . switch-file-term)
             ("C-S-j" . switch-file-term)
             ("s-x" . helm-M-x)
             ("C-:" . company-files)
             ("C-/" . comment-or-uncomment-region-or-whole-line)
             ("M-w" . copy-region-or-whole-line)
             ("s-w" . copy-region-or-whole-line)
             ("M-1" . my-delete-other-windows)
             ("s-1" . my-delete-other-windows)
             ("s-/" . hippie-expand)
             ("C-S-W" . evil-yank)
             ("C-x C-e" . xcwen/evaluate-line)))
    (global-set-key (kbd (car binding)) (cdr binding)))
  (dolist (binding
           '(("C-^" . helm-mini)
             ("C-x C-k" . kill-buffer)
             ("C-]" . spacemacs/jump-to-definition)
             ("C-<tab>" . company-complete)
             ("M-1" . my-delete-other-windows)
             ("M-h" . backward-kill-word-without-_)
             ("C-h" . delete-backward-char)
             ("s-h" . backward-kill-word-without-_)
             ("C-v" . yank)
             ("C-c" . copy-region-or-whole-line)
             ("C-S-h" . xcwen/previous-terminal-or-unindent)
             ("C-S-l" . xcwen/next-terminal-or-indent)))
    (set-evil-all-state-key (kbd (car binding)) (cdr binding)))
  (dolist (binding '(("Y" . copy-region-or-whole-line)
                     ("F" . copy-field-list)
                     ("D" . kill-region-or-whole-line)))
    (set-evil-normal-state-key (car binding) (cdr binding))
    (set-evil-virtual-state-key (car binding) (cdr binding)))
  (define-key evil-normal-state-map [escape] #'xcwen/normal-state-escape)
  (define-key evil-normal-state-map "gf" #'my-goto-file)
  (define-key evil-insert-state-map [escape] #'xcwen/insert-state-escape)
  (define-key evil-insert-state-map (kbd "C-P") #'xcwen/company-previous)
  (define-key evil-insert-state-map (kbd "C-N") #'xcwen/company-next)
  (dolist (key '("C-y" "C-v"))
    (define-key isearch-mode-map (kbd key) #'xcwen/isearch-yank-trimmed)
    (define-key evil-ex-search-keymap (kbd key) #'xcwen/search-yank-trimmed))
  (dolist (key '("M-p" "s-p" "C-p"))
    (define-key minibuffer-local-map (kbd key) #'previous-line-or-history-element))
  (dolist (key '("M-n" "s-n" "C-n"))
    (define-key minibuffer-local-map (kbd key) #'next-line-or-history-element))
  (dolist (map (list company-active-map company-search-map))
    (define-key map (kbd "s-p") #'company-select-previous)
    (define-key map (kbd "s-n") #'company-select-next))
  (define-key company-active-map (kbd "C-N") #'company-select-next)
  (define-key company-active-map (kbd "C-P") #'company-select-previous)
  (with-eval-after-load 'info
    (define-key Info-mode-map (kbd "<return>") #'Info-follow-nearest-node)
    (define-key Info-mode-map (kbd "P") #'Info-next))
  (with-eval-after-load 'sql
    (define-key sql-mode-map (kbd "C-S-I") #'my/toggle-sql-editor-smart))
  (evil-ex-define-cmd "wq" #'xcwen/save-and-switch-to-terminal)
  (evil-ex-define-cmd "q" #'multi-term-goto-last-term))

(defun my-user-config ()
  "Apply personal editing, language, and terminal settings after layers load."
  (xcwen/setup-editing-defaults)
  (xcwen/discover-keyboard-input-device)
  (xcwen/setup-lsp)
  (xcwen/setup-keybindings)
  (xcwen/setup-mode-hooks)
  (xcwen-jump-initialize)

  (when (require 'server nil t)
    (unless (server-running-p)
      (server-start)))

  (setq flycheck-navigation-minimum-level 'warning
        ac-php-project-root-dir-use-truename nil
        flycheck-phpmd-rulesets (list (xcwen/spacemacs-file "phpmd.xml"))
        frame-title-format '("file: %f ")
        yas-snippet-dirs (list (xcwen/spacemacs-file "my-yas")))
  (setq phpcbf-standard (xcwen/spacemacs-file "ruleset.xml")
        phpcbf-executable (xcwen/spacemacs-file "bin/phpcbf")
        php-mode-coding-style 'psr2)
  ;; PHP 文件中检测到 HTML 标签时，不再询问是否切换到 web-mode。
  (setq php-mode-warn-if-html-template nil)

  (dolist (entry '(("\\.wxml\\'" . web-mode)
                   ("\\.wxss\\'" . css-mode)))
    (add-to-list 'auto-mode-alist entry))

  (xcwen/setup-terminals)

  (setq ac-php-tags-backend 'mago
        ac-php-mago-tags-executable
        (expand-file-name "~/ac-php/ac-php-mago-tags/target/release/ac-php-mago-tags"))

  (evilmi-load-plugin-rules '(web-mode vue-mode html-mode nxml-mode nxhtml-mode
                                       sgml-mode php-mode message-mode mhtml-mode)
                            '(simple template html))
  ;; Keep diagnostics on save and documentation on demand.
  (setq flycheck-idle-change-delay 5
        company-idle-delay nil
        flycheck-display-errors-delay 1300000
        flycheck-check-syntax-automatically '(save mode-enabled))
  (setq multi-term-program (or (executable-find "zsh")
                               (executable-find "bash")
                               "/bin/sh"))
  (add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.xml\\'" . web-mode))
  (setq lsp-gopls-build-flags ["--tags=mod_all"])

  (let ((arm-toolchain "/home/jim/pico/arm-none-eabi-gcc/arm-none-eabi/"))
    (when (file-directory-p arm-toolchain)
      (setq ccls-initialization-options
            `(:clang (:extraArgs [,(concat "--gcc-toolchain=" arm-toolchain "bin/")
                                  ,(concat "--sysroot=" arm-toolchain)])))))

  (evil-declare-change-repeat 'company-complete-common)
  (define-key evil-motion-state-map (kbd "C-z") nil)

  (when (fboundp 'yas-reload-all)
    (yas-reload-all)))

;; 终端标签栏和按键配置。
(defvar my/vterm-tab-order nil
  "终端标签的固定顺序，新终端追加到末尾。")

(defun my/vterm-tab-buffers ()
  "按固定顺序显示 vterm buffer，不随终端切换重新排序。"
  (let ((buffers
         (seq-filter
          (lambda (buffer)
            (with-current-buffer buffer
              (derived-mode-p 'vterm-mode)))
          (buffer-list))))
    ;; 清理已关闭的终端，并保留其余标签的位置。
    (setq my/vterm-tab-order
          (seq-filter (lambda (buffer) (memq buffer buffers))
                      my/vterm-tab-order))
    (dolist (buffer buffers)
      (unless (memq buffer my/vterm-tab-order)
        (setq my/vterm-tab-order
              (append my/vterm-tab-order (list buffer)))))
    my/vterm-tab-order))

(defvar-local my/vterm-ssh-label nil
  "SSH 会话期间覆盖目录名的终端标签。")

(defun my/vterm-set-ssh-label (label)
  "由 shell 设置 SSH 标签；空字符串恢复目录名。"
  (when (derived-mode-p 'vterm-mode)
    (setq my/vterm-ssh-label
          (and (string-match-p "\\`ssh-[[:alnum:]._-]+\\'" label) label))
    (force-mode-line-update t)))

(defun my/vterm-tab-name (buffer &optional _buffers)
  "使用终端当前目录的最后一级作为标签名。"
  (with-current-buffer buffer
    (let* ((directory (directory-file-name
                       (file-local-name default-directory)))
           (name (file-name-nondirectory directory)))
      (propertize (or my/vterm-ssh-label (if (string= name "") "/" name))
                  'my/vterm-buffer buffer))))

(defun my/vterm-tab-at-position (position)
  "获取鼠标 POSITION 下的终端标签对应的 buffer。"
  (let ((string-info (posn-string position)))
    (when string-info
      (get-text-property (cdr string-info) 'my/vterm-buffer
                         (car string-info)))))

(defun my/vterm-move-tab (source target)
  "将 SOURCE 标签移动到 TARGET 标签的位置。"
  (let* ((order (copy-sequence (my/vterm-tab-buffers)))
         (source-index (seq-position order source))
         (target-index (seq-position order target)))
    (when (and source-index target-index (not (eq source target)))
      (setq order (delq source order))
      (setq my/vterm-tab-order
            (append (seq-take order target-index)
                    (list source)
                    (seq-drop order target-index)))
      (force-mode-line-update t))))

(defun my/vterm-drag-tab (event)
  "按住终端标签拖动到另一个标签的位置以调整顺序。"
  (interactive "e")
  (let ((source (my/vterm-tab-at-position (event-start event)))
        (target (my/vterm-tab-at-position (event-end event))))
    (when (and (buffer-live-p source) (buffer-live-p target))
      (my/vterm-move-tab source target))))

(defun my/vterm-tab-cache-key (tabs)
  "将各终端的当前目录加入缓存键，cd 后重新生成标签。"
  (append (tab-line-cache-key-default tabs)
          (mapcar (lambda (buffer)
                    (with-current-buffer buffer
                      (list default-directory my/vterm-ssh-label)))
                  tabs)))

(defun my/vterm-close-other-tabs (&optional event)
  "关闭点击按钮所在窗口之外的其他终端 buffer，保留当前终端。"
  (interactive (list last-input-event))
  (let* ((window (and (mouse-event-p event)
                      (posn-window (event-start event))))
         (keep (if (windowp window)
                   (window-buffer window)
                 (current-buffer))))
    (unless (with-current-buffer keep (derived-mode-p 'vterm-mode))
      (user-error "当前窗口不是 vterm 终端"))
    (let ((others (delq keep (copy-sequence (my/vterm-tab-buffers)))))
      (when (and others
                 (yes-or-no-p
                  (format "关闭其他 %d 个终端及其运行中的进程？ "
                          (length others))))
        (dolist (buffer others)
          (when (buffer-live-p buffer)
            ;; 本次批量操作已确认，跳过逐个终端的进程退出确认。
            (with-current-buffer buffer
              (let ((kill-buffer-query-functions nil))
                (dolist (process (process-list))
                  (when (eq (process-buffer process) buffer)
                    (set-process-query-on-exit-flag process nil)))
                (set-buffer-modified-p nil)
                (kill-buffer buffer)))))))
    (force-mode-line-update t)))

(defvar my/vterm-close-others-map
  (let ((map (make-sparse-keymap)))
    (define-key map [tab-line mouse-1] #'my/vterm-close-other-tabs)
    map)
  "终端标签栏的关闭其他按钮键映射。")

(defun my/vterm-close-others-button ()
  "生成终端标签栏的关闭其他按钮。"
  (propertize " [关闭其他] "
              'local-map my/vterm-close-others-map
              'mouse-face 'tab-line-highlight
              'help-echo "关闭其余终端，保留当前终端"))

(defun my/vterm-enable-tabs ()
  "为当前终端启用标签栏，点击 + 新建终端。"
  (setq-local tab-line-tabs-function #'my/vterm-tab-buffers)
  (setq-local tab-line-tab-name-function #'my/vterm-tab-name)
  (setq-local tab-line-cache-key-function #'my/vterm-tab-cache-key)
  (setq-local tab-line-new-tab-choice #'multi-vterm)
  ;; 默认 bury-buffer 只隐藏 buffer，而我们的列表仍包含它；需要真正关闭。
  (setq-local tab-line-close-tab-function #'kill-buffer)
  (setq-local tab-line-tab-map (copy-keymap tab-line-tab-map))
  ;; 在松开鼠标时切换，保留完整的按下—拖动—松开事件。
  (define-key tab-line-tab-map [tab-line down-mouse-1] #'ignore)
  (define-key tab-line-tab-map [tab-line mouse-1] #'tab-line-select-tab)
  (define-key tab-line-tab-map [tab-line drag-mouse-1] #'my/vterm-drag-tab)
  (unless tab-line-mode
    (tab-line-mode 1))
  (setq-local tab-line-format
              '((:eval (my/vterm-close-others-button))
                (:eval (tab-line-format)))))

(defun my/vterm-configure-buffer ()
  "设置当前 vterm 的按键、粘贴和终端标签栏。"
  (when (fboundp 'yas-minor-mode)
    (yas-minor-mode -1))
  (xcwen/vterm-bind-reliable-yank)
  (dolist (binding '(("C-c" . copy-region-or-whole-line)
                     ("C-S-c" . vterm-send-C-c)
                     ("C-p" . vterm-send-up)
                     ("C-n" . vterm-send-down)
                     ("C-a" . vterm-send-C-a)
                     ("C-e" . vterm-send-C-e)
                     ("C-h" . vterm-send-C-h)
                     ("C-l" . vterm-send-C-l)
                     ("C-k" . vterm-send-C-k)
                     ("C-u" . vterm-send-C-u)
                     ("C-w" . vterm-send-C-w)
                     ("C-d" . vterm-send-C-d)
                     ("C-t" . vterm-send-C-t)
                     ("<escape>" . vterm--self-insert)
                     ("C-S-t" . multi-vterm)
                     ("C-S-h" . multi-vterm-prev)
                     ("C-S-l" . multi-vterm-next)
                     ("C-S-I" . my/toggle-sql-editor-smart)
                     ("M-h" . vterm-send-M-h)
                     ("s-h" . vterm-send-M-h)))
    (define-key evil-insert-state-local-map (kbd (car binding)) (cdr binding)))
  (dolist (binding '(("C-z" . nil)
                     ("M-x" . helm-M-x)
                     ("s-x" . helm-M-x)
                     ("C-^" . helm-mini)
                     ("M-w" . copy-region-or-whole-line)
                     ("s-w" . copy-region-or-whole-line)))
    (define-key vterm-mode-map (kbd (car binding)) (cdr binding)))
  (add-to-list 'vterm-eval-cmds
               '("my-vterm-ssh-label" my/vterm-set-ssh-label))
  (my/vterm-enable-tabs))

(defun my/term-send-control-caret ()
  "将 C-^ 发送到当前 term 终端。"
  (interactive)
  (term-send-raw-string "\C-^"))

(defun my/term-configure-buffer ()
  "设置当前 term 终端的 Evil 按键。"
  (when (fboundp 'yas-minor-mode)
    (yas-minor-mode -1))
  (dolist (binding '(("C-y" . term-paste)
                     ("C-v" . term-paste)
                     ("s-v" . term-paste)
                     ("C-c" . copy-region-or-whole-line)
                     ("C-S-c" . term-interrupt-subjob)
                     ("C-p" . term-send-raw)
                     ("C-n" . term-send-raw)
                     ("C-a" . term-send-raw)
                     ("C-e" . term-send-raw)
                     ("C-h" . term-send-raw)
                     ("C-l" . term-send-raw)
                     ("C-k" . term-send-raw)
                     ("C-u" . term-send-raw)
                     ("C-w" . term-send-raw)
                     ("C-d" . term-send-raw)
                     ("C-t" . term-send-raw)
                     ("C-s" . ignore)
                     ("M-h" . term-send-backward-kill-word)
                     ("s-h" . term-send-backward-kill-word)))
    (define-key evil-insert-state-local-map (kbd (car binding)) (cdr binding))))

(defun xcwen/setup-terminals ()
  "配置终端选项并注册可重复加载的终端 hook。"
  (require 'tab-line)
  (require 'seq)
  ;; multi-term 先运行自己的按键 hook，因此必须提前准备好选项。
  (setq term-unbind-key-list '("C-x")
        term-bind-key-alist
        '(("M-1" . my-delete-other-windows)
          ("s-1" . my-delete-other-windows)
          ("M-x" . helm-M-x)
          ("s-x" . helm-M-x)
          ("C-^" . helm-mini)
          ("C-6" . my/term-send-control-caret)
          ("C-S-t" . multi-term)
          ("C-S-h" . multi-term-prev)
          ("C-S-l" . multi-term-next)
          ("C-S-D" . my-join-line)
          ("M-w" . copy-region-or-whole-line)
          ("s-w" . copy-region-or-whole-line))
        ;; VTerm defines C-c C-y and other C-c sequences while loading its
        ;; mode map.  Keep C-c a prefix there; Evil's local insert map above
        ;; still gives a single C-c the custom copy command.
        vterm-keymap-exceptions '("C-c" "C-x"))
  ;; 标签栏现在由同一个 buffer hook 配置，清理旧版的独立 hook。
  (remove-hook 'vterm-mode-hook #'my/vterm-enable-tabs)
  (add-hook 'vterm-mode-hook #'my/vterm-configure-buffer)
  (add-hook 'term-mode-hook #'my/term-configure-buffer)
  ;; 重新加载配置时，也更新已经打开的终端。
  (dolist (buffer (my/vterm-tab-buffers))
    (with-current-buffer buffer
      (my/vterm-configure-buffer))))

(provide 'my-config)

;;; my-config.el ends here
