;;; "Compiled" snippets and support files for `org-mode'  -*- lexical-binding:t -*-
;;; Snippet definitions:
;;;
(yas-define-snippets 'org-mode
                     '(("<vi"
                        "[[${1:link of the video}][file:${2:link of the image}]"
                        "video" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/video" nil nil)
                       ("<v" "#+begin_verse\n$0\n#+end_verse" "verse" nil nil
                        nil "/Users/jim/.spacemacs.d/my-yas/org-mode/verse" nil
                        nil)
                       ("uml" "#+begin_uml\n$1\n#+end_uml" "uml" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/uml" nil nil)
                       ("<ti" "#+title: $0" "title" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/title" nil nil)
                       ("<ta"
                        "#+caption: ${1: caption of the table}\n|${2:column 1} | ${3: column 2} |\n|--------------+----------------|\n"
                        "table" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/table" nil nil)
                       ("<st"
                        "#+style: <link rel=\"stylesheet\" type=\"text/css\" href=\"$1\" />"
                        "style" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/style" nil nil)
                       ("<src" "#+begin_src $1\n  $0\n#+end_src\n" "src" nil nil
                        nil "/Users/jim/.spacemacs.d/my-yas/org-mode/src" nil
                        nil)
                       ("set" "#+setupfile: $0" "setup" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/setup" nil nil)
                       ("<rib"
                        "    :properties:\n    :reveal_background: ${1: path of the image}\n    :reveal_background_trans: ${2: default||cube||page||concave||zoom||linear||fade||none||slide}\n    :end:"
                        "reveal_image_background" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/rv_image_background"
                        nil nil)
                       ("<rsb"
                        ":properties:\n:reveal_background: ${1: #123456}\n:end:"
                        "reveal_single_colored_background" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/rv_background"
                        nil nil)
                       ("<q" "#+begin_quote\n$0\n#+end_quote" "quote" nil nil
                        nil "/Users/jim/.spacemacs.d/my-yas/org-mode/quote" nil
                        nil)
                       ("py_" "#+begin_src python\n$0\n#+end_src" "python" nil
                        nil nil "/Users/jim/.spacemacs.d/my-yas/org-mode/python"
                        nil nil)
                       ("<op"
                        "#+options: h:${1:1} num:${2:t||nil} toc:${3:t||nil}$0"
                        "options" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/options" nil
                        nil)
                       ("matrix_"
                        "\\left \\(\n\\begin{array}{${1:ccc}}\n${2:v1 & v2} \\\\\n$0\n\\end{array}\n\\right \\)"
                        "matrix" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/matrix" nil nil)
                       ("<li" "[[${1:link}][${2:description}]]\n" "link" nil nil
                        nil "/Users/jim/.spacemacs.d/my-yas/org-mode/link" nil
                        nil)
                       ("<lan" "#+language: ${1:en}" "language" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/language" nil
                        nil)
                       ("<ke" "#+keywords: $0" "keywords" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/keywords" nil
                        nil)
                       ("ipy_"
                        "#+begin_src ipython :session ${1:session01} :file ${2:$$(concat (make-temp-name \"./ipython-\") \".png\")} :exports ${3:both}\n$0\n#+end_src"
                        "ipython" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/ipython" nil
                        nil)
                       ("<i" "#+include: $0" "include" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/include" nil
                        nil)
                       ("img_"
                        "<img src=\"$1\" alt=\"$2\" align=\"${3:left}\" title=\"${4:image title}\" class=\"img\" $5/>$0"
                        "img" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/img" nil nil)
                       ("<im"
                        "#+caption: ${1:caption of the image}\n[[file:${2:image_path}]]$0"
                        "image" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/image" nil nil)
                       ("<ht" "#+html:$1" "html" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/html" nil nil)
                       ("fig_"
                        "#+caption: ${1:caption}\n#+attr_latex: ${2:scale=0.75}\n#+label: fig:${3:label}$0"
                        "figure" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/figure" nil nil)
                       ("<ex" "#+begin_export ${1:type}\n$0\n#+end_export"
                        "export" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/export" nil nil)
                       ("<e" "#+begin_example\n$0\n#+end_example" "example" nil
                        nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/exampleblock"
                        nil nil)
                       ("entry_"
                        "#+begin_html\n---\nlayout: ${1:default}\ntitle: ${2:title}\n---\n#+end_html\n"
                        "entry" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/entry" nil nil)
                       ("emb_" "src_${1:lang}${2:[${3:where}]}{${4:code}}"
                        "embedded" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/embedded" nil
                        nil)
                       ("<em" "#+email: $0" "email" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/email" nil nil)
                       ("emacs-lisp_"
                        "#+begin_src emacs-lisp :tangle yes\n$0\n#+end_src"
                        "emacs-lisp" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/emacs-lisp" nil
                        nil)
                       ("elisp_"
                        "#+begin_src emacs-lisp :tangle yes\n$0\n#+end_src"
                        "elisp" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/elisp" nil nil)
                       ("dot_"
                        "#+begin_src dot :file ${1:file} :cmdline -t${2:pdf} :exports none :results silent\n$0\n#+end_src\n[[file:${3:path}]]"
                        "dot" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/dot" nil nil)
                       ("desc" "#+description: $0" "description" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/description"
                        nil nil)
                       ("<da" "#+date: ${1:year}:${2:month}:${3:day}" "date" nil
                        nil nil "/Users/jim/.spacemacs.d/my-yas/org-mode/date"
                        nil nil)
                       ("<c" "#+begin_center\n$0\n#+end_center" "center" nil nil
                        nil "/Users/jim/.spacemacs.d/my-yas/org-mode/center" nil
                        nil)
                       ("<au" "#+author: $0" "author" nil nil nil
                        "/Users/jim/.spacemacs.d/my-yas/org-mode/author" nil nil)))


;;; Do not edit! File generated at Thu Jul 10 16:45:57 2025
