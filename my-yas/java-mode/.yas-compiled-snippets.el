;;; "Compiled" snippets and support files for `java-mode'  -*- lexical-binding:t -*-
;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
                     '(("switch"
                        "switch ( $1 ) {\ncase 1 : $0\n     break;\ncase 2 : \n     break;\ndefault:\n	break;\n}\n"
                        "switch (...) { ... }" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/java-mode/switch" nil
                        nil)
                       ("main"
                        "public static void main (String[] args)  {\n    $0\n}"
                        "main" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/java-mode/main" nil nil)))


;;; Do not edit! File generated at Sun Sep 28 13:30:49 2025
