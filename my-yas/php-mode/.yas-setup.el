;;; .yas-setup.el --- Yasnippet helper functions for PHP snippets

;;; Commentary:

;;; Code:
(require 'yasnippet)

(defun yas-php-get-class-name-by-file-name ()
  "Return name of class-like construct by `file-name'.

\"class-like\" contains class, trait and interface."
  (file-name-nondirectory
   (file-name-sans-extension (or (buffer-file-name)
                                 (buffer-name (current-buffer))))))
(defun yas-php-get-namespace-name-by-file-name ()

  (s-replace-regexp "/" "\\\\"
  (substring
   (s-replace-regexp ".*/app/" "App/"
                     (file-name-directory   (or (buffer-file-name)
                                                (buffer-name (current-buffer))
                                                )) ) 0 -1 )
  )
  )

;;; .yas-setup.el ends here
