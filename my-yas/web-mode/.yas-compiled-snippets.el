;;; Compiled snippets and support files for `web-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'web-mode
                     '(("xdtd" "<include: file=\"../al_common/td_xs_opt.html\" />" "xdtd" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/xdtd.yasnippet" nil nil)
                       ("trdata" "{!!  \\App\\Helper\\Utils::gen_jquery_data($var )  !!}\n" "trdata" nil nil nil "/home/jim/.spacemacs.d/my-yas/web-mode/trdata" nil nil)
                       ("tdopt" "<td class=\"remove-for-not-xs\" ></td>\n\n<td class=\"remove-for-xs\" >操作</td>\n\n<include: file=\"../al_common/td_xs_opt.html\" />\n\n<td class=\"remove-for-xs\" >\n    <div   data-userid=\"[$var.userid]\" data-stu_nick=\"[$var.nick]\">\n        <a href=\"javascript:;\" class=\"btn  fa fa-info td-info\"></a>\n        <a href=\"javascript:;\" class=\"btn fa fa-user opt-user \"></a>\n    </div>\n</td>\n" "tdopt" nil nil nil "/home/jim/.spacemacs.d/my-yas/web-mode/tdopt.yasnippet" nil nil)
                       ("table" "<table   class=\"table table-bordered table-striped\"   >" "table" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/table.yasnippet" nil nil)
                       ("row" "<div class=\"row\">\n    <div class=\"col-xs-6 col-md-2\">\n        <div class=\"input-group \">\n            <span >$1</span>\n            <input type=\"text\" value=\"\"   id=\"$2\"  placeholder=\"$3\" />$0\n        </div>\n    </div>\n</div>\n" "row" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/row.yasnippet" nil nil)
                       ("panel" "<div class=\"panel $1\">\n  <div class=\"panel-heading\">$2</div>\n  <div class=\"panel-body\">\n    $0\n  </div>\n</div>" "panel" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/panel.yasnippet" nil nil)
                       ("on" "$(\"$1\").on (\"${2:click}\",function( ){\n$0\n}); \n" "on" nil nil nil "/home/jim/.spacemacs.d/my-yas/web-mode/on.yasnippet" nil nil)
                       ("modal" "<div class=\"modal fade\" \n     id=\"$1\" \n     tabindex=\"-1\" \n     role=\"dialog\" \n     aria-labelledby=\"$2\" \n     aria-hidden=\"true\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        <button type=\"button\" \n		class=\"close\" \n		data-dismiss=\"modal\" \n		aria-hidden=\"true\">&times;</button>\n        <h4 class=\"modal-title\" id=\"$2\">$3</h4>\n      </div>\n      <div class=\"modal-body\">\n        $0\n      </div>\n      <div class=\"modal-footer\">\n        <button type=\"button\" \n                class=\"btn btn-default\" \n                data-dismiss=\"modal\">${5:Close}</button>\n        <button type=\"button\" \n		class=\"btn btn-primary\">${6:Save}</button>\n      </div>\n    </div>\n  </div>\n</div>" "modal" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/modal.yasnippet" "direct-keybinding" nil)
                       ("icon" "<span class=\"glyphicon glyphicon-$1\"></span>$0" "icon" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/icon.yasnippet" nil nil)
                       ("htmldata" "@extends('layouts.app')\n@section('content')\n\n    <section class=\"content \">\n        \n        <div>\n            <div class=\"row  row-query-list\" >\n                <div class=\"col-xs-12 col-md-5\"  data-title=\"时间段\">\n                    <div  id=\"id_date_range\" >\n                    </div>\n                </div>\n\n                <div class=\"col-xs-6 col-md-2\">\n                    <div class=\"input-group \" >\n                        <span >xx</span>\n                        <input type=\"text\" value=\"\"  class=\"opt-change\"  id=\"id_\"  placeholder=\"\"  />\n                    </div>\n                </div>\n            </div>\n        </div>\n        <hr/>\n        <table     class=\"common-table\"  > \n            <thead>\n                <tr>\n                    <td>字段1 </td>\n                    <td> 操作  </td>\n                </tr>\n            </thead>\n            <tbody>\n                @foreach ( $table_data_list as $var )\n                    <tr>\n                        <td>{{@$var[\"\"]}} </td>\n                        <td>\n                            <div\n                                {!!  \\App\\Helper\\Utils::gen_jquery_data($var )  !!}\n                            >\n                                <a class=\"fa fa-edit opt-edit\"  title=\"编辑\"> </a>\n                                <a class=\"fa fa-times opt-del\" title=\"删除\"> </a>\n\n                            </div>\n                        </td>\n                    </tr>\n                @endforeach\n            </tbody>\n        </table>\n        @include(\"layouts.page\")\n    </section>\n    \n@endsection\n\n" "htmldata" nil nil nil "/home/jim/.spacemacs.d/my-yas/web-mode/htmldata" nil nil)
                       ("div" "<div class=\"$1\"${2: id=\"$3\"}>\n  $0 asdfa\n</div>" "div" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/div.yasnippet" nil nil)
                       ("dis" "style=\"display:none;\"" "dis" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/dis.yasnippet" nil nil)
                       ("container" "<div class=\"container\">\n  $0\n</div>" "container" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/container.yasnippet" nil nil)
                       ("button" "<button type=\"button\" class=\"btn btn-${1:$$(yas-choose-value '(\"default\" \"primary\" \"success\" \"info\" \"warning\" \"danger\" \"link\"))}\" $2>$3</button>$0" "button" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/button.yasnippet" "direct-keybinding" nil)
                       ("a" "<a href=\"$1\" class=\"$2\" $3>$4</a>$0" "<a href=\"\" class=\"\"..</a>" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/alink.yasnippet" "direct-keybinding" nil)
                       ("alert" "<div class=\"alert alert-${1:$$(yas-choose-value '(\"success\" \"info\" \"warning\" \"danger\"))}\">${2:\n<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-hidden=\"true\">&times;</button>}\n  $0\n</div>" "alert" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/alert.yasnippet" nil nil)
                       ("a" "<a class=\"btn btn-${1:$$(yas-choose-value '(\"default\" \"primary\" \"success\" \"info\" \"warning\" \"danger\" \"link\"))}\" role=\"button\" $2>$3</a>$0" "<a class=\"btn\" ..</a>" nil
                        ("twitter-bootstrap")
                        nil "/home/jim/.spacemacs.d/my-yas/web-mode/abutton.yasnippet" "direct-keybinding" nil)))


;;; Do not edit! File generated at Fri Sep 10 11:08:28 2021
