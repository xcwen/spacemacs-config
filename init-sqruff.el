;;; init-sqruff.el --- SQL LSP configuration -*- lexical-binding: t; -*-

(defvar xcwen/sqruff-executable "sqruff"
  "Executable used to start the sqruff language server.")

(defun xcwen/sqruff-server-command ()
  "Return the sqruff language server command."
  (list xcwen/sqruff-executable "lsp"))

(defun xcwen/sql-use-sqruff ()
  "Select sqruff for SQL buffers and enable MySQL highlighting."
  (setq-local lsp-enabled-clients '(sqruff))
  (sql-set-product 'mysql))

(add-hook 'sql-mode-hook #'xcwen/sql-use-sqruff)

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
