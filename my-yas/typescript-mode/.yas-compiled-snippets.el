;;; Compiled snippets and support files for `typescript-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'typescript-mode
                     '(("vue" "import { defineComponent } from 'vue'\n\n\nexport default defineComponent({\n    data() {\n        return {\n        }\n    },\n    setup() {\n        return {\n        }\n    },\n    methods: {\n    }\n});\n" "vue" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/vue" nil nil)
                       ("val" "$(\"$1\").val(${2:\"\"})$0\n" "val" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/val" nil nil)
                       ("reload" "window.location.reload();\n" "reload" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/reload" nil nil)
                       ("rc" "row_$1(e:MouseEvent) {\n  var opt_data = this.get_opt_data(e.target);\n}" "rc" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/rc" nil nil)
                       ("on" "$(\"$1\").on(\"${2:click}\",function(){\n    var opt_data=$(this).get_opt_data();\n	$0\n});\n" "on" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/on" nil nil)
                       ("log" "console.log($1 );" "log" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/log" nil nil)
                       ("for" "for (${1:i = 0}; ${2:i < N}; ${3:++i}){\n    $0\n}\n" "for (...; ...; ...) { ... }" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/for" nil nil)
                       ("dtp" "id_start_time.datetimepicker({\n    datepicker:true,\n    timepicker:true,\n    format:'Y-m-d H:i',\n    step:30,\n    onChangeDateTime :function(){\n\n           var end_time= parseInt(strtotime(id_start_time.val() )) + tt;\n           id_end_time.val(  DateFormat(end_time, \"hh:mm\"));\n   }\n});\n" "dtp" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/dtp" nil nil)
                       ("dlg" "var html_node=dlg_need_html_by_id(\"\");\nhtml_node.find(\"\").html();\nBootstrapDialog.show({\n	title: \"\",\n	message : html_node ,\n	buttons: [{\n		label: '返回',\n		action: function(dialog) {\n			dialog.close();\n		}\n	}, {\n		label: '确认',\n		cssClass: 'btn-warning',\n		action: function(dialog) {\n\n			//get data from dlg\n			var val=html_node.find(\"\").val();\n        \n			dialog.close();\n		}\n	}]\n});\n" "dlg" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/dlg" nil nil)
                       ("data" "$(\"$1\").data(\"${2}\"${3:,\"\"})$0\n" "data" nil nil nil "/Users/jim/.spacemacs.d/my-yas/typescript-mode/data" nil nil)))


;;; Do not edit! File generated at Sat Nov  6 10:38:45 2021
