;;; xcwen-project-jump-integration-tests.el --- Local workspace acceptance -*- lexical-binding: t; -*-
;; Explicit local acceptance tests; not required on machines without these repositories.
(require 'ert)
(add-to-list 'load-path (expand-file-name ".." (file-name-directory (or load-file-name buffer-file-name))))
(require 'xcwen-project-jump)
(setq xcwen-jump-workspace-files
      (list (expand-file-name "examples/project-jump.workspace.json" xcwen-jump--directory)))

(ert-deftest xcwen-jump-local-all-generated-controller-symbols ()
  (xcwen-jump--load-config)
  (dolist (project xcwen-jump--projects)
    (unless (equal (xcwen-jump-project-adapter project) "vue-typescript")
      (let ((groups (make-hash-table :test #'equal)) (count 0))
        (dolist (entry (xcwen-jump--index project))
          (should (file-regular-p (xcwen-jump--file project (alist-get 'proto entry))))
          (push entry (gethash (alist-get 'file (alist-get 'controller entry)) groups)))
        (maphash
         (lambda (file entries)
           (xcwen-jump--with-source
            (xcwen-jump--file project file)
            (lambda ()
              (let ((tokens (xcwen-jump--tokens)))
                (dolist (entry entries)
                  (let* ((ctrl (alist-get 'controller entry))
                         (ranges (xcwen-jump--method-ranges tokens (xcwen-jump-project-adapter project)
                                                          (alist-get 'owner ctrl) (alist-get 'symbol ctrl))))
                    (ert-info ((format "%s %s %s" (xcwen-jump-project-id project) file (alist-get 'id entry)))
                      (should (= 1 (length ranges))))
                    (setq count (1+ count)))))))) groups)
        (message "%s: %d controller symbols verified" (xcwen-jump-project-id project) count)))))

(ert-deftest xcwen-jump-local-vue-spec-and-node-submission ()
  (xcwen-jump--load-config)
  (dolist (case '(("src/views/admin/notify/task_list.vue" "spec: notify_task_crud_spec" "aigc-php" 2)
                  ("src/views/llm_admin/manage/LlmSubmit.vue" "/route__node_admin/llm_admin/manage/submit" "node" 1)
                  ("src/partner/NotificationCurl.vue" "'/partner/data/notify_curl'" "node" 1)
                  ("src/views/mindshow_admin/user/introduction_list.ts" "this.table_init" "aigc-php" 1)))
    (let ((project (xcwen-jump--project "aigc-vue")))
      (xcwen-jump--with-source
       (xcwen-jump--file project (nth 0 case))
       (lambda ()
         (goto-char (point-min)) (search-forward (nth 1 case))
         (let ((refs (plist-get (xcwen-jump--context) :refs)))
           (should (= (nth 3 case) (length refs)))
           (dolist (ref refs) (should (equal (nth 2 case) (xcwen-jump-project-id (plist-get ref :project)))))))))))

;;; xcwen-project-jump-integration-tests.el ends here
