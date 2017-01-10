(setq ac-php-packages
      '(
        flycheck
        ac-php
        php-mode
        ;;auto-complete
        ;;yasnippet
        ))


(defun ac-php/post-init-ac-php ()
  (require 'ac-php)

  )
(defun ac-php/post-init-yasnippet()
  (yas-global-mode 1)
  )


(defun ac-php/post-init-flycheck ()
  (spacemacs/add-flycheck-hook 'php-mode))



(defun ac-php/init-php-mode ()
  (add-hook 'php-mode-hook '(lambda ()
                              (auto-complete-mode t)
                              (require 'ac-php)
                              (yas-global-mode 1)
                              (setq ac-sources  '(ac-source-php ) )
                              ))
  (use-package php-mode
    :defer t
    :mode ("\\.php\\'" . php-mode)))



(defun ac-php/init-ac-php ()
  (use-package ac-php 
    :defer t
    ))



;; (defun ac-php/init-yasnippet ()
;;   (use-package  yasnippet
;;     :defer t
;;     ))








;;; packages.el ends here
