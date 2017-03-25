;;; packages.el --- typescript Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Chris Bowdon <c.bowdon@bath.edu>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq typescriptplus-packages
      '(
        company
        eldoc
        flycheck
        tide
        typescript-mode
        web-mode
        ))

(defun typescriptplus/post-init-company ()
  (when (configuration-layer/package-usedp 'tide)
    (spacemacs|add-company-backends
      :backends company-tide
      :modes typescript-mode)))

(defun typescriptplus/post-init-eldoc ()
  (add-hook 'typescript-mode-hook 'eldoc-mode))

(defun typescriptplus/post-init-flycheck ()
  (spacemacs/enable-flycheck 'typescript-mode))

(defun typescriptplus/init-tide ()
  (use-package tide
    :defer t
    :commands (typescript/jump-to-type-def)
    :init
    (progn
      (evilified-state-evilify tide-references-mode tide-references-mode-map
        (kbd "C-k") 'tide-find-previous-reference
        (kbd "C-j") 'tide-find-next-reference
        (kbd "C-l") 'tide-goto-reference)
      (add-hook 'typescript-mode-hook 'tide-setup)
      (add-to-list 'spacemacs-jump-handlers-typescript-mode 'tide-jump-to-definition))
    :config
    (progn
      (spacemacs/declare-prefix-for-mode 'typescript-mode "mg" "goto")
      (spacemacs/declare-prefix-for-mode 'typescript-mode "mh" "help")
      (spacemacs/declare-prefix-for-mode 'typescript-mode "mn" "name")
      (spacemacs/declare-prefix-for-mode 'typescript-mode "mr" "rename")
      (spacemacs/declare-prefix-for-mode 'typescript-mode "mS" "server")
      (spacemacs/declare-prefix-for-mode 'typescript-mode "ms" "send")

      (defun typescript/jump-to-type-def()
        (interactive)
        (tide-jump-to-definition t))

      (spacemacs/set-leader-keys-for-major-mode 'typescript-mode
        "gb" 'tide-jump-back
        "gt" 'typescript/jump-to-type-def
        "gu" 'tide-references
        "hh" 'tide-documentation-at-point
        "rr" 'tide-rename-symbol
        "Sr" 'tide-restart-server))))

(defun typescriptplus/post-init-web-mode ()
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  ;; FIXME -- this is not good!
  (add-hook 'web-mode-hook
            (lambda ()
              (when (and (buffer-file-name)
                         (string-equal "tsx" (file-name-extension (buffer-file-name))))
                (tide-setup)
                (flycheck-mode +1)
                (eldoc-mode +1)

                (spacemacs|define-jump-handlers web-mode)

                (add-to-list 'spacemacs-jump-handlers-web-mode 'tide-jump-to-definition)

                (spacemacs|add-company-backends
                  :backends company-tide
                  :modes web-mode)

                (when (configuration-layer/package-usedp 'company)
                  (company-mode-on))))))

(defun typescriptplus/init-typescript-mode ()
  (use-package typescript-mode
    :defer t
    :config
    (progn
      (when typescript-fmt-on-save
        (add-hook 'typescript-mode-hook 'typescript/fmt-before-save-hook))
      (spacemacs/set-leader-keys-for-major-mode 'typescript-mode
        "="  'typescript/format
        "sp" 'typescript/open-region-in-playground))))
