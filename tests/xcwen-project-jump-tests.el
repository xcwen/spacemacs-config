;;; xcwen-project-jump-tests.el --- Project navigation regressions -*- lexical-binding: t; -*-
(require 'ert)
(require 'cl-lib)
(add-to-list 'load-path (expand-file-name ".." (file-name-directory (or load-file-name buffer-file-name))))
(require 'xcwen-project-jump)

(defun xcwen-jump-test-write (root path text)
  (let ((file (expand-file-name path root)))
    (make-directory (file-name-directory file) t)
    (with-temp-file file (insert text)) file))

(defmacro xcwen-jump-test-workspace (&rest body)
  (declare (indent 0))
  `(let* ((root (make-temp-file "project jump " t))
          (xcwen-jump-workspace-files (list (expand-file-name "workspace.json" root)))
          (xcwen-jump--loaded-files nil) (xcwen-jump--projects nil) (xcwen-jump--links nil)
          (xcwen-jump--index-cache (make-hash-table :test #'equal))
          (xcwen-jump--source-cache (make-hash-table :test #'equal))
          (xcwen-jump--diagnostics nil) (xcwen-jump--scan-processes nil)
          (xcwen-jump--scan-queue nil) (xcwen-jump--scan-timer nil))
     (unwind-protect
         (progn
           (dolist (backend '("php" "node" "rust" "go"))
             (let* ((extension (cdr (assoc backend '(("php" . "php") ("node" . "ts") ("rust" . "rs") ("go" . "go")))))
                    (owner (cdr (assoc backend '(("php" . "Test") ("node" . "test") ("rust" . "Test") ("go" . "TestController")))))
                    (symbol (if (equal backend "go") "UserList" "user_list")))
               (xcwen-jump-test-write root (concat backend "/proto/src/root/test__user_list.proto") "syntax=\"proto3\";")
               (xcwen-jump-test-write root (concat backend "/controllers/root/test." extension)
                                     (pcase backend
                                       ("php" "<?php class Other { function user_list() {} }\nclass Test {\n// function user_list() {}\nfunction user_list() { $x = '}'; return 1; }\nfunction helper() {}\n}")
                                       ("node" "class test {\n// async user_list() {}\nasync user_list() { const x = '}'; return 1; }\nhelper() {}\n}")
                                       ("rust" "struct Test; impl Test {\npub async fn user_list() { let x = \"}\"; }\nfn helper() {}\n}")
                                       ("go" "package root\nfunc (TestController) UserList() { x := \"}\" }\nfunc (Other) UserList() {}\nfunc helper() {}")))
               (xcwen-jump-test-write root (concat backend "/proto/navigation.json")
                                     (json-encode `((version . 1) (endpoints . [((id . "root/test/user_list") (method . "GET")
                                                                                 (paths . ["/root/test/user_list"])
                                                                                 (proto . "proto/src/root/test__user_list.proto")
                                                                                 (controller . ((file . ,(concat "controllers/root/test." extension))
                                                                                                (owner . ,owner) (symbol . ,symbol))))]))))))
           (xcwen-jump-test-write root "vue/src/views/page.vue" "<script setup lang=\"ts\">\nimport common from '@/utils/common';\ncommon.do_ajax_async('/route__node/root/test/user_list', {});\n</script>")
           (xcwen-jump-test-write root "workspace.json"
                                 (json-encode '((version . 1) (baseDirectory . ".")
                                                (projects . ((php . ((root . "php") (adapter . "php-controller") (endpointIndex . "proto/navigation.json")))
                                                             (node . ((root . "node") (adapter . "typescript-controller") (endpointIndex . "proto/navigation.json")))
                                                             (rust . ((root . "rust") (adapter . "rust-controller") (endpointIndex . "proto/navigation.json")))
                                                             (go . ((root . "go") (adapter . "go-controller") (endpointIndex . "proto/navigation.json")))
                                                             (vue . ((root . "vue") (adapter . "vue-typescript") (sourceRoots . ["src/views"])
                                                                     (companionExtensions . ["vue" "ts"]) (backendScope . ["php" "node" "rust" "go"])
                                                                     (importAliases . ((@/ . "src/")))
                                                                     (gateway . ((stripPrefixes . ["/api"]) (routes . [((prefix . "/route__node") (project . "node"))])))
                                                                     (requests . [((id . "ajax") (importFrom . "@/utils/common") (importName . "default") (members . ["do_ajax_async"]) (urlArgument . 0))
                                                                                  ((id . "partner") (importFrom . "@/partner/api") (importName . "partnerRequest") (project . "node") (urlArgument . 0))])
                                                                     (specProviders . [((id . "crud-spec") (importGlob . "@/gen/crud_spec/*") (urlFields . ["urls.list"]) (project . "php"))]))))))))
           (xcwen-jump--load-config)
           ,@body)
       (dolist (buffer (buffer-list))
         (when (and (buffer-file-name buffer) (file-in-directory-p (buffer-file-name buffer) root))
           (with-current-buffer buffer (set-buffer-modified-p nil)) (kill-buffer buffer)))
       (delete-directory root t))))

(defmacro xcwen-jump-test-source (file &rest body)
  (declare (indent 1))
  `(with-temp-buffer (setq buffer-file-name (expand-file-name ,file root))
     (insert-file-contents buffer-file-name) ,@body))

(ert-deftest xcwen-jump-method-context-four-languages ()
  (xcwen-jump-test-workspace
    (dolist (pair '(("php" . "php") ("node" . "ts") ("rust" . "rs") ("go" . "go")))
      (xcwen-jump-test-source (format "%s/controllers/root/test.%s" (car pair) (cdr pair))
        (goto-char (point-min))
        (search-forward (pcase (car pair) ("go" "x :=") ("rust" "let x") (_ "return 1")))
        (let* ((context (xcwen-jump--context)) (refs (plist-get context :refs))
               (candidates (xcwen-jump--candidates context 'proto)))
          (should (eq (plist-get context :role) 'controller))
          (should (= (length refs) 1))
          (should (equal (xcwen-jump-project-id (plist-get (car refs) :project)) (car pair)))
          (should (string-prefix-p (file-truename (expand-file-name (car pair) root)) (plist-get (car candidates) :file))))))))

(ert-deftest xcwen-jump-proto-stays-in-own-backend ()
  (xcwen-jump-test-workspace
    (dolist (backend '("rust" "go"))
      (xcwen-jump-test-source (concat backend "/proto/src/root/test__user_list.proto")
        (let ((candidate (car (xcwen-jump--candidates (xcwen-jump--context) 'related))))
          (should (eq (plist-get candidate :kind) 'controller))
          (should (equal (xcwen-jump-project-id (plist-get candidate :project)) backend)))))))

(ert-deftest xcwen-jump-comments-helpers-and-nested-functions ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-source "node/controllers/root/test.ts"
      (goto-char (point-min)) (search-forward "// async")
      (should-not (plist-get (xcwen-jump--context) :refs))
      (goto-char (point-min)) (search-forward "helper()")
      (should-not (plist-get (xcwen-jump--context) :refs))
      (erase-buffer)
      (insert "class test {\nasync user_list() {\nfunction nested() { return 3; }\n}\n}")
      (goto-char (point-min)) (search-forward "return 3")
      (should-not (plist-get (xcwen-jump--context) :refs)))))

(ert-deftest xcwen-jump-route-boundaries-and-ambiguity ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-source "vue/src/views/page.vue"
      (goto-char (point-min)) (search-forward "/root/test/user_list")
      (let ((refs (plist-get (xcwen-jump--context) :refs)))
        (should (= 1 (length refs)))
        (should (equal "node" (xcwen-jump-project-id (plist-get (car refs) :project)))))
      (let ((p (xcwen-jump--project "vue")))
        (should (= 4 (length (xcwen-jump--url-refs p "/root/test/user_list" nil "test" 1 2))))
        (should (= 1 (length (xcwen-jump--url-refs p "/api/route__node/root/test/user_list?x=1#z" nil "test" 1 2))))
        (should-not (xcwen-jump--url-refs p "/route__node2/root/test/user_list" nil "test" 1 2))
        (should-error (xcwen-jump--url-refs p "/route__node/root/test/user_list" "go" "test" 1 2) :type 'user-error)))))

(ert-deftest xcwen-jump-import-alias-and-unsaved-buffer ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-source "vue/src/views/page.vue"
      (erase-buffer)
      (insert "<script setup>import { partnerRequest as call } from '@/partner/api';\ncall('/root/test/user_list');</script>")
      (goto-char (point-min)) (search-forward "call('/root")
      (let ((refs (plist-get (xcwen-jump--context) :refs)))
        (should (= 1 (length refs)))
        (should (equal "node" (xcwen-jump-project-id (plist-get (car refs) :project)))))
      (let ((file buffer-file-name))
        (should-not (string-match-p "partnerRequest" (with-temp-buffer (insert-file-contents file) (buffer-string))))))))

(ert-deftest xcwen-jump-dynamic-call-is-not-evaluated ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-source "vue/src/views/page.vue"
      (erase-buffer) (insert "<script setup>import common from '@/utils/common';\ncommon.do_ajax_async(`/route__node${url}`);</script>")
      (should-not (plist-get (xcwen-jump--context) :refs))
      (should xcwen-jump--diagnostics))))

(ert-deftest xcwen-jump-unresolved-call-never-jumps-another-call ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-source "vue/src/views/page.vue"
      (goto-char (point-min)) (search-forward "</script>")
      (goto-char (match-beginning 0))
      (insert "common.do_ajax_async('/route__unknown/root/test/user_list');\n")
      (search-backward "route__unknown")
      (let ((context (xcwen-jump--context)))
        (should-not (plist-get context :refs))
        (should-not (xcwen-jump--candidates context 'related))))))

(ert-deftest xcwen-jump-relative-import-and-generic-call ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-write root "vue/src/partner/api.ts" "export function partnerRequest<T>() {}")
    (xcwen-jump-test-source "vue/src/views/page.vue"
      (erase-buffer)
      (insert "<script setup>import { partnerRequest as call } from '../partner/api';\ncall<{ list: Array<{ id: string }> }>('/root/test/user_list');</script>")
      (goto-char (point-min)) (search-forward "'/root/test")
      (let ((refs (plist-get (xcwen-jump--context) :refs)))
        (should (= 1 (length refs)))
        (should (equal "node" (xcwen-jump-project-id (plist-get (car refs) :project))))))))

(ert-deftest xcwen-jump-spec-follows-imported-symbol-only ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-write root "vue/src/gen/crud_spec/test.ts"
                           "export const wrong = { urls: { list: '/missing' } };\nexport const test_spec: Spec = { urls: { list: '/root/test/user_list' } };")
    (xcwen-jump-test-source "vue/src/views/page.vue"
      (erase-buffer) (insert "<script setup>import { test_spec as spec } from '@/gen/crud_spec/test';\nuseCrudPage({ spec });</script>")
      (goto-char (point-min)) (search-forward "{ spec")
      (let ((refs (plist-get (xcwen-jump--context) :refs)))
        (should (= 1 (length refs)))
        (should (equal "php" (xcwen-jump-project-id (plist-get (car refs) :project))))))))

(ert-deftest xcwen-jump-namespace-path-and-config-errors ()
  (xcwen-jump-test-workspace
    (let ((p (xcwen-jump--project "go")))
      (should-error (xcwen-jump--file p "../outside") :type 'user-error)
      (should-error (xcwen-jump--file p "/etc/passwd") :type 'user-error)
      (make-symbolic-link "/tmp" (expand-file-name "go/link" root))
      (should-error (xcwen-jump--file p "link/file") :type 'user-error)
      (delete-file (expand-file-name "go/proto/navigation.json" root))
      (should-error (xcwen-jump--index p) :type 'user-error))
    (with-temp-buffer (should-error (xcwen-jump--context) :type 'user-error))))

(ert-deftest xcwen-jump-companion-and-multiple-backends ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-write root "vue/src/views/page.ts" "export {}")
    (xcwen-jump-test-source "vue/src/views/page.vue"
      (goto-char (point-min))
      (let ((candidates (xcwen-jump--candidates (xcwen-jump--context) 'related)))
        (should (= 1 (length candidates)))
        (should (eq 'companion (plist-get (car candidates) :kind))))
      (search-forward "root/test/user_list")
      (let ((candidates (xcwen-jump--candidates (xcwen-jump--context) 'all)))
        (should (= 4 (length (cl-remove-if-not (lambda (c) (eq (plist-get c :kind) 'controller)) candidates))))))))

(ert-deftest xcwen-jump-open-and-xref-return ()
  (xcwen-jump-test-workspace
    (let* ((source (find-file-noselect (expand-file-name "go/proto/src/root/test__user_list.proto" root)))
           (xref-history-storage #'xref-window-local-history))
      (save-window-excursion
        (switch-to-buffer source) (goto-char 3)
        (xcwen-jump-related nil)
        (should (string-suffix-p "test.go" buffer-file-name))
        (should (looking-at "UserList"))
        (xref-go-back)
        (should (eq (current-buffer) source))
        (should (= 3 (point)))))))

(ert-deftest xcwen-jump-spec-dependency-cache-invalidates ()
  (xcwen-jump-test-workspace
    (let* ((spec (xcwen-jump-test-write root "vue/src/gen/crud_spec/test.ts"
                                        "export const test_spec = { urls: { list: '/root/test/user_list' } };"))
           (file (xcwen-jump-test-write root "vue/src/views/spec.vue"
                                        "<script setup>import { test_spec } from '@/gen/crud_spec/test'; useCrudPage({ spec: test_spec });</script>"))
           (project (xcwen-jump--project "vue")))
      (should (xcwen-jump--cached-source project file))
      (with-current-buffer (find-file-noselect spec)
        (erase-buffer) (insert "export const test_spec = { urls: { list: '/missing' } };"))
      (should-not (xcwen-jump--cached-source project file)))))

(ert-deftest xcwen-jump-sfc-template-and-rust-trait-are-excluded ()
  (with-temp-buffer
    (setq buffer-file-name "/tmp/test.vue")
    (insert "<template>user's text // { import fake from 'no';</template><script setup>import common from '@/utils/common';</script>")
    (should (equal '(("common" "@/utils/common" "default")) (xcwen-jump--imports (xcwen-jump--tokens)))))
  (with-temp-buffer
    (setq buffer-file-name "/tmp/test.rs")
    (insert "impl Trait for Test { fn user_list() {} }\nimpl Test { pub async fn user_list() { let x = r##\"{ } //\"##; let ch = 'x'; } }")
    (should (= 1 (length (xcwen-jump--method-ranges (xcwen-jump--tokens) "rust-controller" "Test" "user_list"))))))

(ert-deftest xcwen-jump-same-line-methods-have-disjoint-contexts ()
  (with-temp-buffer
    (setq buffer-file-name "/tmp/test.ts")
    (insert "class test { first() { return 1; } async second() { return /{/g; } }")
    (let* ((tokens (xcwen-jump--tokens))
           (first (car (xcwen-jump--method-ranges tokens "typescript-controller" "test" "first")))
           (second (car (xcwen-jump--method-ranges tokens "typescript-controller" "test" "second"))))
      (should (< (nth 1 first) (nth 0 second))))))

(ert-deftest xcwen-jump-missing-target-does-not-open-or-create ()
  (xcwen-jump-test-workspace
    (let ((missing (expand-file-name "go/controllers/missing.go" root)) opened)
      (cl-letf (((symbol-function 'find-file) (lambda (&rest _) (setq opened t))))
        (should-error (xcwen-jump--open (list :file missing :kind 'controller)) :type 'user-error)
        (should-not opened)
        (should-not (file-exists-p missing))))))

;;; xcwen-project-jump-tests.el ends here

(ert-deftest xcwen-jump-picker-defaults-to-proto ()
  (xcwen-jump-test-workspace
    (xcwen-jump-test-source "go/proto/src/root/test__user_list.proto"
      (cl-letf (((symbol-function 'completing-read)
                 (lambda (_prompt choices _predicate _require &optional _initial _history default &rest _)
                   (should (eq (plist-get (cdr (assoc default choices)) :kind) 'proto))
                   default))
                ((symbol-function 'xcwen-jump--open) #'ignore))
        (xcwen-jump-proto)))))

(ert-deftest xcwen-jump-open-preserves-position-in-target-method ()
  (xcwen-jump-test-workspace
    (with-current-buffer (find-file-noselect (expand-file-name "go/controllers/root/test.go" root))
      (goto-char (point-min)) (search-forward "x :=")
      (let* ((position (point)) (context (xcwen-jump--context))
             (candidate (xcwen-jump--candidate (car (plist-get context :refs)) 'controller)))
        (xcwen-jump--open candidate)
        (should (= position (point)))))))

(ert-deftest xcwen-jump-vue-external-script-and-dependency ()
  (xcwen-jump-test-workspace
    (let* ((script (xcwen-jump-test-write root "vue/src/views/logic.ts"
                    "import common from '@/utils/common'; common.do_ajax_async('/route__node/root/test/user_list');"))
           (page (xcwen-jump-test-write root "vue/src/views/external.vue"
                    "<template><div/></template><script lang='ts' src='./logic.ts' />"))
           (project (xcwen-jump--project "vue")))
      (let* ((refs (xcwen-jump--cached-source project page))
             (pages (xcwen-jump--pages (car refs))))
        (should (= 1 (length refs)))
        (should (cl-find (file-truename page) pages :key (lambda (c) (file-truename (plist-get c :file))) :test #'equal)))
      (with-current-buffer (find-file-noselect script)
        (erase-buffer) (insert "export {};"))
      (should-not (xcwen-jump--cached-source project page)))))
