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
                     '(("v_cls" "//SWITCH-TO: vue\nimport { defineComponent } from \"vue\"\n\n\n\nexport default defineComponent({\n    \n    data() {\n    return {\n    };\n    },\n    created() {\n    },\n    methods: {\n    }\n});\n" "v_cls" nil
                        ("definitions")
                        nil "/home/jim/.spacemacs.d/my-yas/vue-mode/v_cls" nil nil)
                       ("ts" "<script lang=\"ts\" src=\"./`(yas-vue-get-name-by-file-name)`.ts\"/>" "ts" nil
                        ("definitions")
                        nil "/home/jim/.spacemacs.d/my-yas/vue-mode/ts" nil nil)
                       ("log" "console.log($0);\n" "log" nil nil nil "/home/jim/.spacemacs.d/my-yas/vue-mode/log" nil nil)
                       ("less" "<style lang=\"less\" scoped >\n$0\n</style>" "less" nil
                        ("definitions")
                        nil "/home/jim/.spacemacs.d/my-yas/vue-mode/less" nil nil)
                       ("icon" "import { ${1:PlusOutlined} } from '@ant-design/icons-vue';\n" "icon" nil nil nil "/home/jim/.spacemacs.d/my-yas/vue-mode/icon" nil nil)
                       ("cls" "<template>\n    <div>\n    $0\n    </div>\n</template>\n<script lang=\"ts\" src=\"./`(yas-vue-get-name-by-file-name)`.ts\"/>\n<style lang=\"less\" scoped >\n</style>" "cls" nil
                        ("definitions")
                        nil "/home/jim/.spacemacs.d/my-yas/vue-mode/cls" nil nil)))


;;; Do not edit! File generated at Sat Sep 30 12:26:03 2023
