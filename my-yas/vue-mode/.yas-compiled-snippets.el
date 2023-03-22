;;; Compiled snippets and support files for `vue-mode'
;;; contents of the .yas-setup.el support file:
;;;
;;; .yas-setup.el --- Yasnippet helper functions for VUE snippets

;;; Commentary:

;;; Code:
(require 'yasnippet)

(defun yas-vue-get-name-by-file-name ()
  "Return name of class-like construct by `file-name'.

\"class-like\" contains class, trait and interface."
  (file-name-nondirectory
   (file-name-sans-extension (or (buffer-file-name)
                                 (buffer-name (current-buffer))))))

;;; .yas-setup.el ends here
;;; Snippet definitions:
;;;
(yas-define-snippets 'vue-mode
                     '(("ts" "<script lang=\"ts\" src=\"./`(yas-vue-get-name-by-file-name)`.ts\"/>" "ts" nil
                        ("definitions")
                        nil "/home/jim/.spacemacs.d/my-yas/vue-mode/ts" nil nil)
                       ("log" "console.log($0);\n" "log" nil nil nil "/home/jim/.spacemacs.d/my-yas/vue-mode/log" nil nil)))


;;; Do not edit! File generated at Thu Mar 16 15:27:10 2023
