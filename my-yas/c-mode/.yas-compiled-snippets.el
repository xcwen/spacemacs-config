;;; Compiled snippets and support files for `c-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'c-mode
                     '(("struct" "struct ${1:Name} {\n    $0\n};" "struct ... { ... }" nil nil nil "/home/jim/.spacemacs.d/my-yas/c-mode/struct" nil nil)
                       ("printf" "printf (\"${1:%s}\\\\n\"${1:$(if (string-match \"%\" yas-text) \",\" \"\\);\")\n}$2${1:$(if (string-match \"%\" yas-text) \"\\);\" \"\")}\n" "printf" nil nil nil "/home/jim/.spacemacs.d/my-yas/c-mode/printf" nil nil)
                       ("main" "#include   <stdio.h>\nint main(int argc, char *argv[])\n{\n    $0\n}\n" "main test" nil nil nil "/home/jim/.spacemacs.d/my-yas/c-mode/main" nil nil)
                       ("ins" "#include <$0>" "include <>" nil nil nil "/home/jim/.spacemacs.d/my-yas/c-mode/ins" nil nil)
                       ("inc" "#include \"${1:`(file-name-nondirectory (file-name-sans-extension (buffer-file-name)))`}.hpp\"\n$0" "include \"\"" nil nil nil "/home/jim/.spacemacs.d/my-yas/c-mode/inc" nil nil)
                       ("fopen" "FILE  *${1:fp} = fopen( ${2:\"file\"}, \"${3:$$(yas/choose-value '(\"r\" \"w\" \"a\" \"r+\" \"w+\" \"a+\" ))}\" ) ;\n" "FILE *fp = fopen(..., ...);" nil nil nil "/home/jim/.spacemacs.d/my-yas/c-mode/fopen" nil nil)))


;;; Do not edit! File generated at Tue Jun 21 09:51:15 2022
