;;; --- 绑定扩展名到特定的模式



(add-hook 'c-mode-hook #'(lambda ( )
                           (modify-syntax-entry ?_ "w" c-mode-syntax-table) ;将 _ 加入 单词中
                           ) )
(add-hook 'lua-mode-hook #'(lambda ( )
                             (modify-syntax-entry ?_ "w" lua-mode-syntax-table) ;将 _ 加入 单词中
                             ) )



(add-hook 'dotenv-mode-hook #'(lambda ( )
                                (modify-syntax-entry ?_ "w" dotenv-mode-syntax-table) ;将 _ 加入 单词中
                                ) )

(add-hook 'protobuf-mode-hook #'(lambda ( )
                                  (modify-syntax-entry ?_ "w" protobuf-mode-syntax-table) ;将 _ 加入 单词中
                                  ) )

(add-hook 'rust-mode-hook #'(lambda ( )
                              (modify-syntax-entry ?_ "w" rust-mode-syntax-table) ;将 _ 加入 单词中
                              ) )




(add-hook 'php-mode-hook #'(lambda ( )
                             (modify-syntax-entry ?$ "." php-mode-syntax-table)
                             (modify-syntax-entry ?_ "w" php-mode-syntax-table) ;将 _ 加入 单词中
                             ))

(add-hook 'php-ts-mode-hook #'(lambda ( )
                                (modify-syntax-entry ?$ "." php-ts-mode--syntax-table)
                                (modify-syntax-entry ?_ "w" php-ts-mode--syntax-table ) ;将 _ 加入 单词中
                             ))


(add-hook 'dart-mode-hook #'(lambda ( )
                              (modify-syntax-entry ?_ "w" dart-mode-syntax-table) ;将 _ 加入 单词中
                              ))




(add-hook 'json-mode-hook #'(lambda ( )
                              (modify-syntax-entry ?_ "w" json-mode-syntax-table) ;将 _ 加入 单词中
                              ))






(require 'org)
(modify-syntax-entry ?_ "w" org-mode-syntax-table) ;将 _ 加入 单词中




(add-hook 'c++-mode-hook #'(lambda ( )
                             (modify-syntax-entry ?_ "w" c++-mode-syntax-table) ;将 _ 加入 单词中
                             ) )

(add-hook 'term-mode-hook #'(lambda ( )
                              (modify-syntax-entry ?_ "w" term-mode-syntax-table) ;将 _ 加入 单词中
                              (modify-syntax-entry ?. "w" term-mode-syntax-table) ;将 _ 加入 单词中
                              (modify-syntax-entry ?- "w" term-mode-syntax-table) ;将 _ 加入 单词中
                              (modify-syntax-entry ?~ "w" term-mode-syntax-table) ;将 _ 加入 单词中
                              (modify-syntax-entry ?/ "w" term-mode-syntax-table) ;将 _ 加入 单词中
                              ) )
(add-hook 'sh-mode-hook #'(lambda ( )
                            (modify-syntax-entry ?_ "w" sh-mode-syntax-table) ;将 _ 加入 单词中
                            (modify-syntax-entry ?. "w" sh-mode-syntax-table) ;将 _ 加入 单词中
                            (modify-syntax-entry ?- "w" sh-mode-syntax-table) ;将 _ 加入 单词中
                            (modify-syntax-entry ?~ "w" sh-mode-syntax-table) ;将 _ 加入 单词中
                            ) )

(add-hook 'erlang-mode-hook #'(lambda ( )
                                (modify-syntax-entry ?_ "w" erlang-mode-syntax-table) ;将 _ 加入 单词中
                                ))

(add-hook 'elixir-mode-hook #'(lambda ( )
                                (modify-syntax-entry ?_ "w" elixir-mode-syntax-table) ;将 _ 加入 单词中
                                ))




(add-hook 'nxml-mode-hook #'(lambda ( )
                              (modify-syntax-entry ?= "." nxml-mode-syntax-table)
                              (modify-syntax-entry ?_ "w" nxml-mode-syntax-table) ;将 _ 加入 单词中
                              ) )

(add-hook 'web-mode-hook #'(lambda ( )
                             (modify-syntax-entry ?+ "." web-mode-syntax-table)
                             (modify-syntax-entry ?- "w" web-mode-syntax-table) ;将 _ 加入 单词中
                             (modify-syntax-entry ?_ "w" web-mode-syntax-table) ;将 _ 加入 单词中
                             ))


(add-hook 'python-mode-hook #'(lambda ( )
                                (modify-syntax-entry ?_ "w" python-mode-syntax-table) ;将 _ 加入 单词中
                                ) )

(add-hook 'js2-mode-hook #'(lambda ( )
                             (modify-syntax-entry ?_ "w" js2-mode-syntax-table) ;将 _ 加入 单词中
                             ))

(add-hook 'sql-mode-hook #'(lambda ( )
                             (modify-syntax-entry ?_ "w" sql-mode-syntax-table) ;将 _ 加入 单词中
                             ) )

(add-hook 'emacs-lisp-mode-hook #'(lambda ( )
                                    (modify-syntax-entry ?- "w" emacs-lisp-mode-syntax-table) ;将 _ 加入 单词中
                                    ) )





(add-hook 'typescript-mode-hook
          #'(lambda ( )
              (message " do typescript-mode-hook hook ")
              (modify-syntax-entry ?_ "w" typescript-mode-syntax-table) ;将 _ 加入 单词中
              ;;(require 'ts-align)
              ;;(typescript-align-setup)
              ))

(provide 'init-syntax-table)

;;; init-mode.el ends here
