

```diff
diff --git a/layers/+emacs/org/packages.el b/layers/+emacs/org/packages.el
index e548cdd7b..2abcfe0f5 100644
--- a/layers/+emacs/org/packages.el
+++ b/layers/+emacs/org/packages.el
@@ -93,7 +93,7 @@
       (setq evil-org-use-additional-insert t
             evil-org-key-theme `(textobjects
                                  navigation
-                                 additional
+                                 ;; additional
                                  ,@(when org-want-todo-bindings '(todo)))))
     :config
     (spacemacs|hide-lighter evil-org-mode)))

```
