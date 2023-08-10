;;; Compiled snippets and support files for `dart-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'dart-mode
                     '(("slw" "class ${1:Name} extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return Container($0);\n  }\n}" "StatelessWidget" nil
                        ("flutter")
                        nil "/home/jim/.spacemacs.d/my-yas/dart-mode/statelesswidget" nil nil)
                       ("sfw" "class ${1:Name} extends StatefulWidget {\n  @override\n  $1State createState() => $1State();\n}\n\nclass $1State extends State<$1> {\n  @override\n  Widget build(BuildContext context) {\n    return Container($0);\n  }\n}" "StatefulWidget" nil
                        ("flutter")
                        nil "/home/jim/.spacemacs.d/my-yas/dart-mode/statefulwidget" nil nil)
                       ("set" "${1:Type} _${2:Name};\nset $2($1 $2) => _$2 = $2;" "setter" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/setter" nil nil)
                       ("part" "part of ${1:Part}$0" "part" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/part" nil nil)
                       ("main" "main(List<String> args) {\n  $0\n}" "main" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/main" nil nil)
                       ("log" "print(\" $0 \");" "log" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/log" nil nil)
                       ("is" "@override\nvoid initState() {\n  super.initState();\n  $0\n}" "initState" nil
                        ("flutter")
                        nil "/home/jim/.spacemacs.d/my-yas/dart-mode/initstate" nil nil)
                       ("imp" "import '${1:Library}';$0" "import" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/import" nil nil)
                       ("impl" "implements ${1:Name}$0" "impl" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/impl" nil nil)
                       ("get" "${1:Type} _${2:Name};\n$1 get $2 => _$2;$0" "getter" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/getter" nil nil)
                       ("getset" "${1:Type} _${2:Name};\n$1 get $2 => _$2;\nset $2($1 $2) => _$2 = $2;$0" "getset" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/getset" nil nil)
                       ("afun" "Future<${1:Type}> ${2:Name}($3) async {\n  $0\n}" "funca" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/funca" nil nil)
                       ("fun" "${1:Type} ${2:Name}($3) {\n  $0\n}" "fun" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/func" nil nil)
                       ("fori" "for(var ${1:obj} in ${2:collection}) {\n  $0\n}" "fori" nil nil
                        ((yas-indent-line 'fixed)
                         (yas-wrap-around-region nil))
                        "/home/jim/.spacemacs.d/my-yas/dart-mode/fori" nil nil)
                       ("for" "for(var i = ${1:0}; i ${2:< 10}; i${3:++}) {\n  $0\n}" "for" nil nil
                        ((yas-indent-line 'fixed)
                         (yas-wrap-around-region nil))
                        "/home/jim/.spacemacs.d/my-yas/dart-mode/for" nil nil)
                       ("ext" "extends ${1:Name}$0" "ext" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/ext" nil nil)
                       ("dis" "@override\nvoid dispose() {\n  super.dispose();\n  $0\n}" "dispose" nil
                        ("flutter")
                        nil "/home/jim/.spacemacs.d/my-yas/dart-mode/dispose" nil nil)
                       ("dcd" "@override\nvoid didChangeDependencies() {\n  super.didChangeDependencies();\n  $0\n}" "didChangeDependencies" nil
                        ("flutter")
                        nil "/home/jim/.spacemacs.d/my-yas/dart-mode/didchangedependencies" nil nil)
                       ("cls" "class ${1:Name} {\n  $0\n}" "class" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/class" nil nil)
                       ("blt" "abstract class ${1:Name} implements Built<$1, $1Builder> {\n  factory $1([void Function($1Builder) updates]) = _$$1;\n  $1._();\n\n  $0\n}" "built_value" nil
                        ("dart")
                        nil "/home/jim/.spacemacs.d/my-yas/dart-mode/builtvalue" nil nil)
                       ("acls" "abstract class ${1:Name} {\n  $0\n}" "aclass" nil nil nil "/home/jim/.spacemacs.d/my-yas/dart-mode/aclass" nil nil)))


;;; Do not edit! File generated at Wed Aug  2 12:41:57 2023
