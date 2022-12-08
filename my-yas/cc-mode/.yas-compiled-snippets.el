;;; Compiled snippets and support files for `cc-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
                     '(("switch" "switch ( $1 ) {\ncase 1 : $0\n     break;\ncase 2 : \n     break;\ndefault:\n	break;\n}\n" "switch (...) { ... }" nil nil nil "/home/jim/.spacemacs.d/my-yas/cc-mode/switch" nil nil)
                       ("once" "#ifndef ${1:_`(upcase (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))`_H_}\n#define $1\n\n$0\n\n#endif /* $1 */" "#ifndef XXX; #define XXX; #endif" nil nil nil "/home/jim/.spacemacs.d/my-yas/cc-mode/once" nil nil)
                       ("ih" "#include \"` (file-name-nondirectory (file-name-sans-extension (buffer-file-name)))`.hpp\"\n" "#incude <self.hpp>" nil nil nil "/home/jim/.spacemacs.d/my-yas/cc-mode/ih" nil nil)
                       ("hd" "/**\n * ============================================================\n * @file   `(file-name-nondirectory (buffer-file-name))`\n * @author `header-user-name` (`header-user-email`)\n * @date   `(format-time-string \"%Y-%m-%d %H:%M:%S\")`\n *\n * \n * @brief  $1\n * \n * ============================================================\n */\n$0\n\n" "header" nil nil nil "/home/jim/.spacemacs.d/my-yas/cc-mode/hd" nil nil)))


;;; Do not edit! File generated at Fri Dec  2 16:24:57 2022
