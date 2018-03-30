;;; Compiled snippets and support files for `php-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'php-mode
                     '(("vdoc" "/**\n * @var  $0\n */\n" "doc of var/member" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/vdoc" nil nil)
                       ("u" "\\App\\Helper\\Utils::" "u" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/u" nil nil)
                       ("sqlrow" "$sql=$this->gen_sql(\"select  $1 from  %s  where  $2  \",\n					 self::DB_TABLE_NAME,\n					 $3 );\nreturn $this->main_get_row($sql);\n\n" "sqlrow" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/sqlrow" nil nil)
                       ("sqllist" "$sql=$this->gen_sql(\"select  $1 from  %s  where  $2  \",\n					 self::DB_TABLE_NAME,\n					 $3 );\nreturn $this->main_get_list($sql);\n\n" "sqllist" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/sqllist" nil nil)
                       ("pagefun" "/**\n *\n */\npublic function $1($page_info, $order_by_str, $start_time, $end_time  )\n{\n    $where_arr=[];\n\n\n    $this->where_arr_add_time_range($where_arr, \"field_name\", $start_time, $end_time);\n    //$this->where_arr_add_int_or_idlist($where_arr,\"field_name\" , $vaule);\n    $sql=$this->gen_sql_new(\n            \"select *  \"\n            .\" from  %s \"\n            .\" where  %s \"\n            .\"  $order_by_str \",\n    				self::DB_TABLE_NAME,\n    				$where_arr);\n\n    return $this->main_get_list_by_page($sql,$page_info);\n}\n\n" "pagefun" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/pagefun" nil nil)
                       ("log" "\\App\\Helper\\Utils::logger($0);\n" "log" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/log" nil nil)
                       ("for" "for (${1:iss = 0}; ${2:i < N}; ${3:++i})\n{\n    $0\n}\n" "for (...; ...; ...) { ... }" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/for" nil nil)
                       ("fdoc" "/**\n *\n * @return  $0\n */\n" "fdoc  doc of function" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/fdoc" nil nil)
                       ("face" "use Illuminate\\Support\\Facades\\\\$0 ;\n" "face" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/face" nil nil)
                       ("d" "\\App\\Helper\\Utils::debug_to_html( $0 );\n" "d" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/d" nil nil)
                       ("ctrlfun" "public function $1()\n{\n\n    $page_info = $this->get_in_page_info();\n    list( $order_in_db_flag, $order_by_str, $order_field_name,$order_type )\n        = $this->get_in_order_by_str([],\"lesson_start asc\",[\n            \"grade\" => \"s.grade\",\n        ]);\n\n    list($start_time,$end_time)= $this->get_in_date_range_day(0 );\n\n    $ret_info=$this->t_xx->get_list($page_info, $order_by_str, $start_time, $end_time  );\n    foreach ($ret_info[\"list\"] as &$item) {\n        //\\App\\Helper\\Utils::unixtime2date_for_item($item, \"add_time\");\n        //E\\Epad_type::set_item_value_str($item, \"has_pad\");\n    }\n    return $this->pageView(__METHOD__, $ret_info);\n\n}\n" "ctrlfun" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/ctrlfun" nil nil)
                       ("c" "\\App\\Helper\\Common::$0\n" "c" nil nil nil "/home/jim/site-lisp/config/my-yas/php-mode/c" nil nil)))


;;; Do not edit! File generated at Mon Jan 29 17:15:48 2018
