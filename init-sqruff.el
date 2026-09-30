;;; init-sqruff.el --- SQL LSP configuration -*- lexical-binding: t; -*-

(defvar xcwen/sqruff-executable "sqruff"
  "Executable used to start the sqruff language server.")

(defconst xcwen/sql-mysql-checker-executable
  (expand-file-name "bin/sql-mysql-check"
                    (file-name-directory (or load-file-name buffer-file-name)))
  "Executable used to validate SQL through a .sqls connection.")

(defun xcwen/sqruff-server-command ()
  "Return the sqruff language server command."
  (list xcwen/sqruff-executable "lsp"))

(defun xcwen/sql-use-sqruff ()
  "Select sqruff for SQL buffers and enable MySQL highlighting."
  (setq-local lsp-enabled-clients '(sqruff))
  (sql-set-product 'mysql))

(add-hook 'sql-mode-hook #'xcwen/sql-use-sqruff)

(defun xcwen/sql-check-with-mysql ()
  "Check the current SQL buffer with MySQL and show Flycheck errors."
  (interactive)
  (require 'flycheck)
  (unless (file-executable-p xcwen/sql-mysql-checker-executable)
    (user-error "SQL checker is not executable: %s"
                xcwen/sql-mysql-checker-executable))
  (flycheck-mode 1)
  (setq-local flycheck-checker 'sql-mysql-prepare)
  (setq-local flycheck-check-syntax-automatically nil)
  (flycheck-buffer)
  (flycheck-list-errors))

(with-eval-after-load 'flycheck
  (flycheck-define-checker sql-mysql-prepare
    "Check SQL syntax with MySQL PREPARE using .sqls/config.json."
    :command ("sql-mysql-check" source-inplace)
    :error-patterns
    ((error line-start (file-name) ":" line ":" column ": error: "
            (message) line-end))
    :modes (sql-mode))
  (setq flycheck-sql-mysql-prepare-executable
        xcwen/sql-mysql-checker-executable)
  (add-to-list 'flycheck-checkers 'sql-mysql-prepare))

(with-eval-after-load 'lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection #'xcwen/sqruff-server-command)
    :major-modes '(sql-mode)
    :priority 1
    :server-id 'sqruff)))

(with-eval-after-load 'sql
  (spacemacs/set-leader-keys-for-major-mode 'sql-mode
    "==" #'lsp-format-buffer))

(provide 'init-sqruff)
;;; init-sqruff.el ends here
