;;; config.el --- PHP Layer config File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Kosta Harlan <kosta@kostaharlan.net>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; variables

(spacemacs|defvar-company-backends php-mode)

(spacemacs|define-jump-handlers php-mode ac-php-find-symbol-at-point)

(defvar ac-php-completion-backend 'ac-source-php
  "Completion backend used by company.
Available options are `ghci', `intero' and `ghc-mod'. Default is
`ghci'.")
