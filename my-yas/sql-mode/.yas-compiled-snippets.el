;;; Compiled snippets and support files for `sql-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'sql-mode
                     '(("table" "drop table if exists db_ike.t_${1:} ;\nCREATE TABLE db_ike.t_${1:} (\n${1:}_id int(11) unsigned  NOT NULL AUTO_INCREMENT COMMENT 'id',\ncreated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT '创建时间',\nupdated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP  ON UPDATE CURRENT_TIMESTAMP  COMMENT '更新时间',\nPRIMARY KEY (${1:}_id )\n) ENGINE=InnoDB DEFAULT  CHARSET=utf8mb4 COMMENT='jim/表';\n" "table" nil nil nil "/home/jim/.spacemacs.d/my-yas/sql-mode/table" nil nil)))


;;; Do not edit! File generated at Wed Jan 10 15:09:53 2024
