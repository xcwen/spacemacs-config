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
(condition-case nil
    (spacemacs|defvar-company-backends  php-mode)
  (error
   ;; try this one:
   ))

(spacemacs|define-jump-handlers php-mode ac-php-find-symbol-at-point)
