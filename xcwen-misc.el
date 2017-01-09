;;; xcwen-misc.el --- Some basic utility function of xcwen
;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-09-11 09:53:02 Saturday by taoshanwen>

;; This  file is free  software; you  can redistribute  it and/or
;; modify it under the terms of the GNU General Public License as
;; published by  the Free Software Foundation;  either version 3,
;; or (at your option) any later version.

;; This file is  distributed in the hope that  it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You  should have  received a  copy of  the GNU  General Public
;; License along with  GNU Emacs; see the file  COPYING.  If not,
;; write  to  the Free  Software  Foundation,  Inc., 51  Franklin
;; Street, Fifth Floor, Boston, MA 02110-1301, USA.


;;; Commentary:
(defvar term-local-cmd-start-line-regex-str
  "^localhost.*\\$[ \t]*$"
  "doc ,line like:
localhost:~/site-lisp/config$"
  )



;;   fix test
(defun  tramp-tramp-file-p  ( file-name )
 nil)

;;; Code:
(defun check-in-linux ()
  (string= system-type "gnu/linux" )
    )
(defun sudo-save ()
  (interactive)
  (if (not buffer-file-name)
      (write-file (concat "/sudo:root@localhost:" (ido-read-file-name "File:")))
    (write-file (concat "/sudo:root@localhost:" buffer-file-name)))) 

(defun add-to-alist (alist-var elt-cons &optional no-replace)
  "Add to the value of ALIST-VAR an element ELT-CONS if it isn't there yet.
If an element with the same car as the car of ELT-CONS is already present,
replace it with ELT-CONS unless NO-REPLACE is non-nil; if a matching
element is not already present, add ELT-CONS to the front of the alist.
The test for presence of the car of ELT-CONS is done with `equal'."
  (let ((existing-element (assoc (car elt-cons) (symbol-value alist-var))))
    (if existing-element
        (or no-replace
            (rplacd existing-element (cdr elt-cons)))
      (set alist-var (cons elt-cons (symbol-value alist-var)))))
  (symbol-value alist-var))






(defun term-send-esc ()
  "Send ESC in term mode."
  (interactive)
  (term-send-raw-string "\e"))

(defun set-tags-config-for-cur-file ()
  "DOCSTRING"
  (interactive)
  (let ((tags-dir (get-tags-dir) ) ) 
	(message "tags-dir=%s" tags-dir)
	(if tags-dir 
		(progn
		  (setq  tags-file (concat tags-dir  ".tags/TAGS"  ))
		  (if (string= major-mode  "c++-mode")
			  (progn
				(setq tags-table-list (list "~/.emacs.d/TAGS" tags-file ))
				(setq cscope-database-regexps
					  (list
					   ( list "^/"
							  ( list t )
							  ( list (concat  tags-dir ".tags/" ))
							  ))))
			(setq tags-table-list (list  tags-file))))
	  ;;没有找到
	  (setq tags-table-list '( "~/.emacs.d/TAGS"  ) ))))

(defun cscope-find-functions-calling-this-function-and-set-tags-file (symbol)
  "Display functions calling a function."
  (interactive (list
		(cscope-prompt-for-symbol
		 "Find functions calling this function: " nil)
		))

  (set-tags-config-for-cur-file)
  (let ()
    (setq cscope-symbol symbol)
    (cscope-call (format "Finding functions calling: %s" symbol)
		 (list "-3" symbol) nil 'cscope-process-filter
		 'cscope-process-sentinel)
    ))


(defun my-recentf-open ()

  "open recent files.  In ido style if applicable --lgfang"
  (interactive)
  (let* ((path-table (mapcar
                      (lambda (x) (cons (file-name-nondirectory x) x))
                      recentf-list))
         (file-list (mapcar (lambda (x) (file-name-nondirectory x))
                            recentf-list))
         (complete-fun (if (require 'ido nil t)
                           'ido-completing-read
                         'completing-read))
         (fname (funcall complete-fun "File Name: " file-list)))
    (find-file (cdr (assoc fname path-table)))))


(defun yas-org-very-safe-expand ()
  (let ((yas/fallback-behavior 'return-nil)) (yas-expand)))

(defun set-evil-all-state-key ( key func )
  (define-key evil-insert-state-map key  func) 
  (define-key evil-normal-state-map  key  func ) 
  (define-key evil-visual-state-map key func) 
  (define-key evil-emacs-state-map key func) 
  (define-key evil-motion-state-map key func) 
  ) 

(defun set-evil-normal-state-key ( key func )
  (define-key evil-normal-state-map key  func )
  )
(defun set-evil-insert-state-key ( key func )
  (define-key ((evil-insert-state-map)) key  func )
  )


(defun set-evil-normal-state-key-on-mode ( mode-map key func )
  (evil-define-key 'normal  mode-map  key  func )
  )

(defun set-evil-normal-or-insert-state-key-on-mode ( mode-map key func )
  (evil-define-key 'normal  mode-map  key  func )
  (evil-define-key 'insert mode-map  key  func )
  )

(defun set-evil-all-state-key-on-mode ( mode-map key func )
  (evil-define-key 'normal  mode-map  key  func )
  (evil-define-key 'insert mode-map  key  func )
  (evil-define-key 'motion mode-map  key  func )
  (evil-define-key 'virtual mode-map  key  func )
  (evil-define-key 'emacs mode-map  key  func )
  )



(defun js-get-file-at-point ()
  (interactive)
  (let( cur-path  pos-info)
        (save-excursion
          (let (file-name-begin file-name-end file-name  )

            (skip-chars-backward "a-zA-Z0-9._/"   ) 
            (setq file-name-begin (point))

            (skip-chars-forward "a-zA-Z0-9._/"   ) 

            (setq file-name-end (point))
            (setq cur-path (buffer-substring-no-properties file-name-begin file-name-end )) 
            (setq file-name ( concat  (nth 1  (s-split "/" cur-path  )) ".php" ) )
            (setq pos-info ( concat "/function[ \t]*" (nth 2  (s-split "/" cur-path  )) ) )
            (setq cur-path (concat (nth 0  (s-split "/public/" (buffer-file-name)) ) "/app/Http/Controllers/" file-name ))
            (message "xxx %s" cur-path)
            ))
        (list cur-path pos-info)
    ))
(defun web-get-file-at-point ()
  (interactive)
  (let( cur-path  pos-info)
        (save-excursion
          (let (file-name-begin file-name-end file-name  )

            (skip-chars-backward "a-zA-Z0-9._/"   ) 
            (setq file-name-begin (point))

            (skip-chars-forward "a-zA-Z0-9._/"   ) 


            (setq file-name-end (point))
            (setq cur-path (buffer-substring-no-properties file-name-begin file-name-end )) 

            (if (s-match "\.js"  cur-path )
                (setq cur-path (concat (nth 0  (s-split "/template/" (buffer-file-name)) ) "/webroot/" cur-path ))
              (progn 
                (setq file-name ( concat  (nth 1  (s-split "/" cur-path  )) ".class.php" ) )
                (setq pos-info ( concat "/function.*" (nth 2  (s-split "/" cur-path  )) ) )
                (setq cur-path (concat (nth 0  (s-split "/template/" (buffer-file-name)) ) "/handler/" file-name )))
            )
            ))
        (list cur-path pos-info)
    ))

(defun php-get-html-in-handle ()
    "DOCSTRING"
  (interactive)
  (let (line-txt opt-file opt-dir )
    (save-excursion
      (goto-char (point-min))

      (when (search-forward "APP_PATH" nil t  )
        (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
        (if (string-match   "APP_PATH[ \t]*\\.[ \t]*'\\(.*\\)'[ \t]*;"   line-txt)
            (setq opt-dir  (concat "../" (match-string  1 line-txt)  ) )
          )
        ))


    (if opt-dir 
        (save-excursion
          (let (file-name-begin file-name-end )

            (skip-chars-backward "a-zA-Z0-9._/"   ) 
            (setq file-name-begin (point))

            (skip-chars-forward "a-zA-Z0-9._/"   ) 

            (setq file-name-end (point))

            (setq opt-file (concat opt-dir "/"  (buffer-substring-no-properties file-name-begin file-name-end )) )

            )))

    (list opt-file  nil )
    ))


;; (switch-cc-to-h ))))
(defun switch-file-opt ()
  "DOCSTRING"
  (interactive)
  (let (  line-txt  opt-file  file-list obj-file check-file-name file-name file-name-fix  (use-default t) pos-info )
    (save-excursion
      (goto-char (point-min))
      (when (search-forward "SWITCH-TO:" nil t  )
        (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
        (if (string-match   "SWITCH-TO:[ \t]*\\([^ \t]*\\)[ \t]*"   line-txt)
            (setq  opt-file (match-string  1 line-txt)))))

    (if (and opt-file   (file-directory-p  opt-file) )
        (progn ;;目录
          (setq file-name (file-name-nondirectory (buffer-file-name)))
          (setq file-name-fix (file-name-base  file-name))

          (setq file-list (directory-files opt-file))
          (while (and file-list (not obj-file) )
            (setq check-file-name (car file-list) )
            (setq file-list (cdr file-list) )

            (if (and
                 (string= (file-name-base check-file-name ) file-name-fix  ) ;;
                 (not (string= file-name check-file-name   ));;后缀不一样
                 )
                (setq obj-file  (concat opt-file "/" check-file-name) ))))
      (setq obj-file opt-file))
   ;;check for   php html js
    (unless obj-file
      (let ((path-name (buffer-file-name)) ctrl-name action-name tmp-arr )
        (cond
         ((string= major-mode  "php-mode")

          (progn
            (setq ctrl-name (f-base  (f-base path-name )) )
            (save-excursion
              (let (line-txt  ) 
                (beginning-of-defun)
                (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                (setq tmp-arr (s-match  ".*function[ \t]+\\([a-zA-Z0-9_]*\\)"  line-txt ) )
                (when tmp-arr
                  (setq action-name (nth 1 tmp-arr) )
                  )))
            (when (and (s-match "/Controllers/" path-name )  (not (string= action-name "__construct")) )
              (setq  obj-file  (concat "../../../resources/views/" ctrl-name  "/" action-name ".blade.php" ) )
              )
            ))

         ((string= major-mode  "web-mode" )
          (setq tmp-arr (s-match  "/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).blade.php"  path-name ) )
          (when tmp-arr
            (setq  ctrl-name   (nth 1 tmp-arr) )
            (setq  action-name   (nth 2 tmp-arr) ))

          (when (s-match "/views/" path-name )  
            (setq  obj-file  (concat"../../../public/page_ts/" ctrl-name  "/" action-name ".ts" ) )
            
            )
          (let (js-obj-file)
          (when ( and (not (f-exists? obj-file )) (s-match "/views/" path-name )   )
            (setq  js-obj-file  (concat"../../../public/page_js/" ctrl-name  "/" action-name ".js" ) )
            (when (  f-exists? js-obj-file ) (setq obj-file js-obj-file)  )
            ))
          )
         ((string= major-mode  "jade-mode" )
          (setq tmp-arr (s-match  "/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).jade"  path-name ) )
          (when tmp-arr
            (setq  ctrl-name   (nth 1 tmp-arr) )
            (setq  action-name   (nth 2 tmp-arr) ))

          (when (s-match "/views/" path-name )  
            (setq  obj-file  (concat"../../web_public/page_ts/" ctrl-name  "/" action-name ".ts" ) )
            
            )
          )


         ((string= major-mode  "js2-mode" )
          (setq tmp-arr (s-match  "page_js/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).js"  path-name ) )
          (when tmp-arr
            (setq  ctrl-name   (nth 1 tmp-arr) )
            (setq  action-name   (nth 2 tmp-arr) ))
          (when (s-match "/public/page_js/" path-name )  
            (setq  obj-file  (concat"../../../app/Http/Controllers/" ctrl-name  ".php" ) )
            (setq pos-info ( concat "/function[ \t]+" action-name "[ \t]*("  ) )

            ))
         ((string= major-mode  "typescript-mode" )
          (setq tmp-arr (s-match  "/public/page_ts/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).ts"  path-name ) )
          ;; php ts
          (when tmp-arr
            (setq  ctrl-name   (nth 1 tmp-arr) )
            (setq  action-name   (nth 2 tmp-arr) )
            (when (s-match "/public/page_ts/" path-name )  
              (setq  obj-file  (concat"../../../app/Http/Controllers/" ctrl-name  ".php" ) )
              (setq pos-info ( concat "/function[ \t]+" action-name "[ \t]*("  ) )

              ))

          ;; nodejs javascript ts
          (message "  nodejs javascript ts: %s" path-name)
          (setq tmp-arr (s-match  "/web_public/page_ts/\\([a-zA-Z0-9_-]*\\)/\\([a-zA-Z0-9_-]*\\).ts"  path-name ) )
          (when tmp-arr

            (message " check OK " )
            (setq  ctrl-name   (nth 1 tmp-arr) )
            (setq  action-name   (nth 2 tmp-arr) )
            (setq  obj-file  (concat "../../../routes/" ctrl-name  ".ts" ) )
            (setq pos-info ( concat "/public[ \t]+" action-name "[ \t]*("  ) )

            ) 
          ;; nodejs  ts

          (when (s-match "/routes/" path-name )  
            (progn
              (setq ctrl-name (f-base  (f-base path-name )) )
              (save-excursion
                (let (line-txt  ) 
                  (re-search-backward "[ \t]*public[ \t]+"  0 t 1 )
                  (setq line-txt (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
                  (setq tmp-arr (s-match  ".*public[ \t]+\\([a-zA-Z0-9_]*\\)"  line-txt ) )
                  (when tmp-arr
                    (setq action-name (nth 1 tmp-arr) )
                    )))
              (when (and   (not (string= action-name "constructor")) )
                (setq  obj-file  (concat "../views/" ctrl-name  "/" action-name ".jade" ) )
                )
              ))

         
          ))))

      (when obj-file
        (unless (f-exists? obj-file)
          (message "no find %s" obj-file )
          (setq use-default  nil)
          (setq obj-file nil)
          )
        )
    
      (if obj-file
          (let(line-txt (move-flag t ))
            (find-file obj-file)
            (when pos-info  
              (when (string=(substring-no-properties pos-info 0 1 )  "/")


                (when (> (line-number-at-pos )  2)   
                  (save-excursion
                    (if (string= major-mode "typescript-mode" )
                        (re-search-backward "[ \t]*public[ \t]+" 0 t 1 )
                      ( evil-backward-section-begin)
                      )
                    (setq line-txt (buffer-substring-no-properties
                                    (line-beginning-position)
                                    (line-end-position )))
                    (message "line-txt:%s" line-txt)
                    (when (s-matches-p (substring-no-properties pos-info 1 ) line-txt  ) ;;同一个区域
                      (setq move-flag nil ))
                    ))
                (when move-flag
                  (goto-char (point-min))
                  (re-search-forward  (substring-no-properties pos-info 1 ) )
                  (next-line))
                )
              ))

        (when use-default (switch-cc-to-h))
      )))




(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
(replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string))
)


(defun proto-get-cur-cmd()
  "DOCSTRING"
  (let (cmdid  obj-tag)
    (setq  cmdid (thing-at-point 'symbol))
	(if cmdid 
		(progn 
		  (setq obj-tag  cmdid)
		  (setq obj-tag (replace-regexp-in-string  "\\(.*\\)_in$" "\\1" cmdid ) ) 
		  (if (string= obj-tag cmdid)
			  (setq obj-tag (replace-regexp-in-string  "\\(.*\\)_out$" "\\1" cmdid ) ))
		  (if (string= obj-tag cmdid)
			  (setq obj-tag (replace-regexp-in-string  "\\(.*\\)_cmd$" "\\1" cmdid ) ))
		  (if (string= obj-tag cmdid)
			  (setq obj-tag (replace-regexp-in-string  "send_\\(.*\\)$" "\\1" cmdid ) ))



		  (if (string= obj-tag cmdid)
			  (setq obj-tag (replace-regexp-in-string  "^n_\\(.*\\)$" "\\1" cmdid ) ))

		  (if (string= obj-tag cmdid)
			  (setq obj-tag (replace-regexp-in-string  "0[xX]\\(.*\\)$" "\\1" cmdid ) ))

		  obj-tag
		  )
	 "" 
	  ))
  )
;;
(defun find-cmd-def ( cmdid )
  "查找命令号所在调用函数"
  ;;(interactive  (list (read-string cmdid) "sCMD:")) 
  (interactive (list (read-string  (format "CMD(default %s) :" (proto-get-cur-cmd) ) )) )

	      
  ;;(interactive (find-tag-interactive "Find tag: "))

  (let (cmd-name obj-tag ) 
    (setq obj-tag (if (string= cmdid "")
		      (proto-get-cur-cmd )
		    cmdid
		    ))

    ;;重置tags 文件
    (set-tags-config-for-cur-file)
    


    (if (get-buffer  "*tmp-cmd-info*") (kill-buffer "*tmp-cmd-info*"))
    ;;(call-process  "awk"  nil "*tmp-cmd-info*" nil  "-F[,(]"  "{print   substr(tolower(v),0,length(v)-3); } "  (format  "v=%s" cmdid )  "./.tags/bind_all.h"   )
    (call-process  "awk"  nil "*tmp-cmd-info*" nil  "-F[,(]"  " {cmdid=$2; if ( tolower( substr(cmdid,1,2 )) == \"0x\" ){cmdid=substr(cmdid,3 );} if (tolower(cmdid)==tolower(v) ||  tolower(v)==tolower($3)    ){printf (\"%s\",$3); exit;}  } "  (format  "v=%s" obj-tag )  "./.tags/bind_all.h"   )

    (with-current-buffer
	"*tmp-cmd-info*"
      (setq cmd-name  (trim-string (buffer-substring-no-properties (point-min) (point-max)) ) )
      (kill-buffer  "*tmp-cmd-info*")
      (message "cmd funcion:%s" cmd-name)

      )
    (if  (string= (trim-string cmd-name) "")
		(message  "nofind cmd:[%s] " obj-tag   )
      (find-tag   cmd-name nil nil))
    )

  )

;;------------------------------------------------------------
(defun show-dict ()
  "翻译"
  (interactive)
  (let ((cmd "goldendict")(word))
    (setq word (if (and  mark-active
	    (not  (= (region-beginning) (region-end) )))
	(buffer-substring-no-properties (region-beginning)(region-end)) (current-word )))
    (call-process  cmd nil 0 nil  word   )
    ))
(defun fcitx-inactivate-input-method()
  "fcitx 关闭输入法"
  (interactive)
  (when (check-in-linux)
    (call-process  "fcitx-remote" nil 0 nil  "-c") )
  )

(defun fcitx-activate-input-method()
  "fcitx 开启输入法"
  (interactive)
  (when (check-in-linux)
    (call-process  "fcitx-remote" nil 0 nil  "-o")))


(defun proto-show-msg ()
  "查看协议数据"
  (interactive)
  (let (line-msg message-type io-type hex-buf io-type-arg)
    (setq line-msg (buffer-substring-no-properties
		    (line-beginning-position)
		    (line-end-position )))
    ;;找到buffer
    (string-match
     "^.*\\([A-Za-z]+\\)\\([IO]\\)[ \t]*\\[\\(.*\\)\\]\\[\\([0-9A-F ]*\\)\\][\t ]*$"
     line-msg)
    (setq cat_proto "/home/jim/framework/gen_proto/gen_proto_app/bin/cat_proto")
    
    (match-string 0 line-msg)
    (setq message-type (match-string  1 line-msg))
    (setq io-type (match-string  2 line-msg))
    (setq hex-buf (match-string  4 line-msg))
    (if (not hex-buf)
	(progn
	  
	  (message "it no a data line "))
      (progn
	(when (string= message-type "C")
	  (progn
	    (setq io-type-arg (if (string= io-type "I")  "-i" ""))
	    (setq bigend-flag "-b")
	    (setq header-arg "-fcmdid,H,4,2|userid,L,6,4|seqid,L,10,4|result,l,14,4")
	    (setq proto-src-arg "-p/home/jim/server/online/trunk/gen_proto/python/ultraman_online_proto.py") ))
	(when (string= message-type "S")
	  (progn
	    (setq io-type-arg (if (string= io-type "I")  "" "-i"))
	    (setq bigend-flag "")
	    (setq header-arg "")
	    (setq proto-src-arg "-p/home/jim/work/ultraman/online/trunk/gen_proto/python/ultraman_db_proto.py") ))
	
	;;(message "%s %s %s %s %s %s"  cat_proto io-type-arg bigend-flag header-arg proto-src-arg hex-buf  )
	(if (get-buffer  "*proto-out*") (kill-buffer "*proto-out*"))
	(call-process  cat_proto nil "*proto-out*" nil  io-type-arg bigend-flag header-arg proto-src-arg hex-buf  )
	(delete-other-windows)
	(unless (get-buffer-window  "*proto-out*")
	  (set-window-buffer (split-window-below 17)  "*proto-out*"))
	(switch-to-buffer-other-window "*proto-out*")
	(goto-line 20)
	(other-window 1)
	))))

;;全屏
(defun my-fullscreen ()
  (interactive)
  (when (check-in-linux)
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     '(2 "_NET_WM_STATE_FULLSCREEN" 0)) )
  )
;;最化大
(defun my-maximized ()
  (interactive)
  (when (check-in-linux ) 
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
    (x-send-client-message
     nil 0 nil "_NET_WM_STATE" 32
     '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)) )
  )
;;(progn (skip-syntax-backward "w_") (point))

(defun get-whole-word-pos (&optional arg)
  "得到当前单词的开始和结束"
  (save-excursion
    (let ((beg
	   (progn (skip-syntax-backward "w_") (point)))
	  (end
	   (progn (skip-syntax-forward "w_") (point))
	  ))
      (list beg end))))
(defun copy-whole-word (&optional arg)
  "Copy a sequence of string into kill-ring"
  (interactive)
  (let ( pos )
    (setq pos (get-whole-word-pos))
    (copy-region-as-kill (car pos) (cadr pos))
    ))
(defun gen-function-as-kill ()
  "由类的函数定义 生成函数的实现"
  (interactive)
  (save-excursion
    (let (func-msg class-type pos re-str arg-1 )
      ;;找到当前行定义的函数
      (beginning-of-line)
      (setq func-msg (buffer-substring-no-properties (point)
		       (re-search-forward ";" (point-max) t 1 )  ))
      ;;处理前置的 virtual static
      (setq func-msg (replace-regexp-in-string  "\\`[ \t\n]*\\(virtual\\|static\\)[ \t\n]+\\(.*\\)" "\\2" func-msg   ) ) 

	  ;;去掉其中的 =0 , =NULL 之类的东西 
      (setq func-msg (replace-regexp-in-string  "=[ \t]*[a-zA-Z0-9]\+" ""  func-msg ))

      

      ;;找到是哪一个类的
      (re-search-backward "^\s*class" 0 t 1) 
      (forward-word 2)
      (setq pos (get-whole-word-pos))
      (setq class-type (buffer-substring-no-properties
			(car pos)(cadr pos )))
      ;;在函数名前加上 class-name::
      ;;在最后加上 {}
      (setq re-str "\\`[ \t\n]*\\([a-zA-Z0-9_]+[ \t]*[&*]*\\)[ \t\n]*\\(\\(.\\|\n\\)*\\);")

      (setq arg-1  (replace-regexp-in-string re-str "\\1" func-msg))
      (if (or (string= arg-1 class-type ) (string= arg-1 (concat  "~" class-type  ) ) )
          (setq func-msg (replace-regexp-in-string
                          re-str
                          (concat "\n"  class-type "::\\1\\2\n{\n\n}\n" )
                          func-msg
                          ))

        (setq func-msg (replace-regexp-in-string
                        re-str
                        (concat "\n\\1\n" class-type "::\\2\n{\n\n}\n" )
                        func-msg
                        )))

      ;;加入剪切列表
      (kill-new func-msg))))


(defun xcwen-beautify-xml ()
    (interactive)
    (save-excursion
        (shell-command-on-region (point-min) (point-max) "xmllint --format -" (buffer-name) t)
        (nxml-mode)
        (indent-region begin end)))

(defun xcwen-beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
"python -c 'import sys,json; data=json.loads(sys.stdin.read()); print json.dumps(data,sort_keys=True,indent=4).decode(\"unicode_escape\").encode(\"utf8\",\"replace\")'"
      (current-buffer) t)))

;;删除当前单词
(defun kill-whole-word (&optional arg)
  "kill a word  into kill-ring"
  (interactive)
  (let (pos)
    (setq pos (get-whole-word-pos))
    (kill-region (car pos) (cadr pos))))
(defun upper-or-lower-whole-word (&optional arg)
  "kill a word  into kill-ring"
  (interactive)
  (let (pos cur_char)
    (setq pos (get-whole-word-pos))
    (setq cur_char (following-char))
    (if (and (>= cur_char ?a ) (<= cur_char ?z )  )
	(upcase-region (car pos) (cadr pos))
      (downcase-region (car pos) (cadr pos))
      )
    ))
;;---------------------------------------------------------------------------







(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
	((looking-at "\\s)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))
;;---------------------------------------------------------------------------

(defun join-line-0 (arg)
  ""
  (interactive "p")
  (join-line 0))

(defun comment-or-uncomment-whole-line(num)
  (save-excursion
    (beginning-of-line)
    (let ((begin-point (point)))
      (forward-line num)
      (comment-or-uncomment-region	 begin-point (point)))
    ))

(defun copy-whole-line(num)
  (save-excursion
    (beginning-of-line)
    (let ((begin-point (point)))
      (forward-line num)
      (copy-region-as-kill begin-point (point)))
    ))

(defun get-mark-pos-ex ()
  "跨行，则得到所有行的开始和结束"
  (setq reg-begin-pos (region-beginning))
  (setq reg-end-pos (region-end))
  (forward-char (- reg-begin-pos (point) ))
  (beginning-of-line)
  (setq  start-pos  (point))
  (forward-char (- reg-end-pos (point) ))  ;;------
  (if (= (current-column) 0 )
      (backward-char 1 ))
  (end-of-line)
  (setq  end-pos  (if (= (point) (point-max) ) (point-max) (+ (point) 1 ) ))
  (list start-pos end-pos ))

(defun mark-region-ex(&optional arg)
  (interactive "P")
  (setq tmp-mark-pos  (get-mark-pos-ex))
  (forward-char (- (car tmp-mark-pos) (point) ))
  (push-mark (cadr tmp-mark-pos) nil t ))



;;功能
;;
(defun opt-region-or-whole-line(opt-type   arg)
  "提供高级的复制 剪切功能
"
  (save-excursion 
	(cond
	 ( (string= opt-type "copy")
	   (setq do-region-func 'copy-region-as-kill do-line-func  'copy-whole-line  ))

	 ( (string= opt-type "comment")
	   (setq do-region-func 'comment-or-uncomment-region do-line-func   'comment-or-uncomment-whole-line ))
	 (t
	  (setq do-region-func 'kill-region do-line-func  'kill-whole-line  )))

    (if (and  mark-active
              (not  (= (region-beginning) (region-end) ))
              )
        (if (string-match "\n"
                          (buffer-substring-no-properties (region-beginning)(region-end)))
            (progn
              (setq tmp-mark-pos  (get-mark-pos-ex))
              (funcall do-region-func (car tmp-mark-pos) (cadr tmp-mark-pos)  )
              ) ;-----------
          (funcall do-region-func (region-beginning) (region-end) ))
      (progn
        (or arg (setq arg 1))
        (message "%s line :%d"  opt-type arg)
        (funcall do-line-func arg)))))

;;;###autoload
(defun copy-region-or-whole-line(&optional arg)
  "有选择区域时：
	1:复制的内容是跨行的：复制区域所在的所有行的内容。不仅仅是区域内的内容
	2:复制的内容没有跨行：复制区域中的内内容
没有选择区域时: 
	1:复制所在的行
	2:支持复制多行.  如 复制3行是  M-3 C-w  
"
  (interactive "P")
  (opt-region-or-whole-line "copy" arg)
  )

;;;###autoload
(defun comment-or-uncomment-region-or-whole-line(&optional arg)
  "有选择区域时：
	1:comment的内容是跨行的：comment区域所在的所有行的内容。不仅仅是区域内的内容
	2:comment的内容没有跨行：comment区域中的内内容
没有选择区域时: 
	1:comment所在的行
	2:支持comment多行.  如 comment3行是  M-3 C-w  
"
  (interactive "P")
  (opt-region-or-whole-line "comment" arg)
  )


;;;###autoload
(defun kill-region-or-whole-line(&optional arg)
  "有选择区域时：
	1:剪切的内容是跨行的：剪切区域所在的所有行的内容。不仅仅是区域内的内容
	2:剪切的内容没有跨行：剪切区域中的内内容
没有选择区域时: 
	1:剪切所在的行
	2:支持剪切多行.  如 剪切3行是  M-3 C-k
"
  (interactive "P")
  (opt-region-or-whole-line "kill" arg))



(defun find-tag-ex (  &optional next-p)
  ""
  (interactive "P")
  ;; (find-tag  (current-word) next-p t)
  (let ((cur-word (current-word )))
    (find-tag   cur-word next-p nil)
    )
  )

(defun find-tag-next-ex (  )
  ""
  (interactive "")
  (find-tag-ex  t)
  )


(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))


;;------------------------------------------------------------

(defun begin-line-and-insert-line ( arg)
  "C-o"
  (interactive "P")
  (move-beginning-of-line 1)
  (open-line 1))

;;
(defun  region-indent-ex ( is-add )
  "整体缩进"
  (interactive)
  (save-excursion
    (setq mark-pos  (get-mark-pos-ex))
    (message  "%d %d" (car mark-pos) (cadr mark-pos) )
    (if is-add
	(replace-regexp "^" "    " nil (nth 0 mark-pos) (- (nth 1 mark-pos) 1) )
      (replace-regexp "\\(^\t\\)\\|\\(^    \\)" "" nil (nth 0 mark-pos) (- (nth 1 mark-pos)  1)))
    ))
(defun region-indent-add ()
  "DOCSTRING"
  (interactive)
  (region-indent-ex t)
  )
(defun region-indent-sub ()
  "DOCSTRING"
  (interactive)
  (region-indent-ex nil)
  )
(defun get-tags-dir  ()
  "DOCSTRING"
  (let (tags-dir tags-file) 
    (setq tags-dir (file-name-directory (buffer-file-name)  ))
    (while (not (or (file-exists-p  (concat tags-dir  ".tags" )) (string= tags-dir "/") ))
	  (setq tags-dir  ( file-name-directory (directory-file-name  tags-dir ) ) ))
	(if (string= tags-dir "/") (setq tags-dir nil )   )
	tags-dir
	)
  )
(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

(defun get-build-args  ()
  "得到编译参数, build/self.cxx_flags.conf   "
  (let (build-dir build-file) 
    (setq build-dir (file-name-directory (buffer-file-name)  ))
    (while (not (or (file-exists-p  (concat build-dir  "build/self.cxx_flags.conf" ) ) (string= build-dir "/") ))
	  (setq build-dir  ( file-name-directory (directory-file-name  build-dir ) ) )
	  )
	(append ac-clang-flags-g++-base  (if (string= build-dir "/") nil 
	  (split-string (get-string-from-file (concat build-dir  "build/self.cxx_flags.conf" )  ))
	))
  ))


(defun my-ac-mode-complete ()
  "对mode 指定匹配方案, go , c++  "
  (interactive)
  (if (string= major-mode  "go-mode")
	  ( auto-complete  '(ac-source-go ))
	(progn
	  (if  (get-tags-dir) ;; 自己的代码 
		  (progn 
			;;查找编译参数	
			(let ((build-args  (get-build-args))  old-flags  ) 
			  ;;(message "build-args :%s" build-args)
			  ;;设置当前ac-clang-flags 配置
			  (if build-args
				  (progn
					(setq old-flags ac-clang-flags )
					(setq  ac-clang-flags build-args )  ))
			  
			  ( auto-complete  '(ac-source-clang ))

			  ;;还原
			  (if build-args
				  (setq  ac-clang-flags old-flags ))
			  ))

        (progn
          (message "use ac-source-rtags")
		( auto-complete  '(ac-source-rtags ))
        ))
	  ))) 

(defun remake-tags ()
  "DOCSTRING"
  (interactive)
  (let ((tags-dir (get-tags-dir) ) ) 
	(message "remake %s" tags-dir )
	(if tags-dir 
		(message (shell-command-to-string  (concat tags-dir "/.tags/metags") )))))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun wcy-mark-some-thing-at-point()
  (interactive)
  (let* ((from (point))
         (a (mouse-start-end from from 1))
         (start (car a))
         (end (cadr a))
         (goto-point (if (= from start )
			 end
                       start)))
    (if (eq last-command 'wcy-mark-some-thing-at-point)
        (progn
          ;; exchange mark and point
          (goto-char (mark-marker))
          (set-marker (mark-marker) from))
      (push-mark (if (= goto-point start) end start) nil t)
      (when (and (interactive-p) (null transient-mark-mode))
        (goto-char (mark-marker))
        (sit-for 0 500 nil))
      (goto-char goto-point))))
(defun backward-kill-word-without-_ ()
  "DOCSTRING"
  (interactive)
  (if (and  mark-active
	    (not  (= (region-beginning) (region-end) ))
	    )
      (kill-region (region-beginning) (region-end) )
    (progn
      (let (start-pos end-pos)
	(setq start-pos (point))
	(save-excursion
	  (skip-chars-backward "^a-z0-9A-Z一-龠^")
	  (skip-chars-backward "a-z0-9一-龠^")
	  (skip-chars-backward "A-Z")
	  (setq end-pos (point))
	  )
	(kill-region start-pos end-pos)))))

(defun  multi-term-goto-last-term ()
  "DOCSTRING"
  (interactive)
  (let (find-flag opt-file-name find-path-str init-cmd  line-txt)
    (setq opt-file-name (buffer-file-name)   )

    ;;go to file location dir 
    (if (and  opt-file-name  (file-exists-p opt-file-name ) )
        (setq file-path-str (file-name-directory opt-file-name ) )
      (setq file-path-str (concat  (getenv "HOME") "/" )))

    (dolist  ( opt-buffer (buffer-list) )
      (let (check-free-term)
        (with-current-buffer opt-buffer
          (setq check-free-term
                (and
                 ;;term-mode
                 (string= "term-mode" major-mode) 
                 ;;本地，处于命令行完成状态
                 (string-match term-local-cmd-start-line-regex-str (buffer-substring-no-properties (line-beginning-position) (line-end-position )))
                 ;;同一个目录
                 (string= file-path-str default-directory )
                     )))
      
        (when check-free-term 
          (switch-to-buffer opt-buffer) 
          (setq find-flag t)
          (return )
        )))

    (unless  find-flag 
      (dolist  ( opt-buffer (buffer-list) )
        (let (check-free-term)
          (with-current-buffer opt-buffer
            (setq check-free-term
                  (and
                   ;;term-mode
                   (string= "term-mode" major-mode) 
                   ;;本地，处于命令行完成状态
                   (string-match term-local-cmd-start-line-regex-str (buffer-substring-no-properties (line-beginning-position) (line-end-position )))
                   
                   )))
          
          (when check-free-term 
            (switch-to-buffer opt-buffer) 
            (setq find-flag t)
            (return )
            ))))


    (unless find-flag
      (multi-term  ))

    ;;(evil-local-mode 0)
    ;;(undo-tree-mode -1 )


    (setq line-txt (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position )))

    ;;(message "===%s %s" default-directory file-path-str )
    ;;进入当前文件所在文件夹
    (when (and  (not (string= file-path-str default-directory ))
                (string-match term-local-cmd-start-line-regex-str line-txt ) ;;本地，处于命令行完成状态
                )
      (setq init-cmd  (concat "cd " file-path-str  " # goto file location   \r" ) )
      (term-send-raw-string init-cmd ))
    ))


(defun switch-file-term ()
  " 交换终端和文件"
  (interactive)
  ;;(message "%s %s %s" "====" opt-file-name "kkk")
  (if (string= major-mode  "term-mode")
      (evil-buffer nil )
    (powerline-reset)
    (multi-term-goto-last-term)
    ))
(defun switch-case-char (&optional arg)
  ""
  (interactive)
  (let (pos cur_char)
    (setq pos (if (< (point) (point-max)) (+ (point) 1) (point) ))
    (setq cur_char (following-char))
    (if (and (>= cur_char ?a ) (<= cur_char ?z )  )
	(upcase-region (point) pos)
      (downcase-region (point)  pos)
      )
    ))


(defun yas-expand-for-vim(&optional field)
  "Expand a snippet before point.

If no snippet expansion is possible, fall back to the behaviour
defined in `yas-fallback-behavior'.

Optional argument FIELD is for non-interactive use and is an
object satisfying `yas--field-p' to restrict the expansion to."
  (interactive)
  (setq yas--condition-cache-timestamp (current-time))
  (let (templates-and-pos)
    (unless (and yas-expand-only-for-last-commands
                 (not (member last-command yas-expand-only-for-last-commands)))
      (setq templates-and-pos (if field
                                  (save-restriction
                                    (narrow-to-region (yas--field-start field)
                                                      (yas--field-end field))
                                    (yas--templates-for-key-at-point))
                                (yas--templates-for-key-at-point))))
    (if templates-and-pos
        (yas--expand-or-prompt-for-template (first templates-and-pos)
                                            (second templates-and-pos)
                                            (third templates-and-pos))
	  (progn
		(message "do indent-for-tab-command  %s" major-mode )
        (when ( string= major-mode "web-mode")
          (message  "xx:%s"(web-mode-language-at-pos)  )
          )
		(let ((c (char-before)))
		  (cond
		   ((and (or  (string= major-mode "c-mode") (string= major-mode "c++-mode"))
                (or (eq ?\. c)
					;; ->
					(and (eq ?> c)
						 (eq ?- (char-before (1- (point)))))
					;; ::
					(and (eq ?: c)
						 (eq ?: (char-before (1- (point)))))))
			(my-ac-mode-complete  ))

		   ((and (or
                  (string= major-mode "php-mode")
                  (and (string= major-mode "web-mode")
                       (string=   (web-mode-language-at-pos)  "php"  ))) 
                 (or 
					;; ->
					(and (eq ?> c)
						 (eq ?- (char-before (1- (point)))))
                    ;;\
					(eq ?\\ c)
					;; ::
					(and (eq ?: c)
						 (eq ?: (char-before (1- (point)))))))

            (message "do ac-source-php")
			(auto-complete '(ac-source-php)  ))


		   ((and (string= major-mode "go-mode")  (eq ?\. c))
			( auto-complete  '(ac-source-go )))

		   ((and (string= major-mode "java-mode")  (eq ?\. c))
			( auto-complete  ))
		   ((and (string= major-mode "python-mode")  (eq ?\. c))
			(elpy-company-backend  `interactive ))
		   ((and (string= major-mode "erlang-mode")  (eq ?\: c))
			( auto-complete  ))
		   ((and (string= major-mode "js2-mode")  (eq ?\. c))
			( auto-complete  ))
		   ((and (string= major-mode "typescript-mode")  (eq ?\. c))
			( company-complete ))

		   ((and (string= major-mode "elixir-mode")  (eq ?\. c))
			( company-complete ))






		   ( t (indent-for-tab-command ))))
		
		)
	  )))



(defun search-proto-info ()
  "Search for symbol near point.
If FORWARD is nil, search backward, otherwise forward."
  (interactive)
  (let (string obj-str tmp-str )
    (setq isearch-forward t)
    (setq string (evil-find-symbol  t) )
    
    (if  (null string) 
        (error "No proto item under point"))

    (setq tmp-str "")
    (cond
     ((string= (substring string -4 ) "_out" )
      (setq tmp-str (substring string 0 -4)))
     ((string= (substring string -3 ) "_in" )
      (setq tmp-str (substring string 0 -3)))
     ((string= (substring string -4 ) "_cmd" )
      (setq tmp-str (substring string 0 -4)))
     )
    (if (not (string= tmp-str ""))
	(setq obj-str  (format "\\_<%s_cmd\\_>\\|\\_<%s_in\\_>\\|\\_<%s_out\\_>" tmp-str tmp-str tmp-str   ))
      (setq obj-str string))
    

    (evil-search obj-str t t)))


(defun yas-reset ()
    "DOCSTRING"
  (interactive)
  (let ()
    (yas-recompile-all)
    (yas-reload-all)
    ))
(defun my-align-comments (beginning end)
  "Align comments within marked region."
  (interactive "*r")
  (let (indent-tabs-mode align-to-tab-stop)
    (align-regexp beginning end  "//"  )))
(defadvice find-function (before jim-find-funtion  activate compile)
  (interactive (find-function-read))
  (xref-push-marker-stack )
  )
(defun my-jump-set-evil-local-map( jump-fun  &optional back-fun   )

  (define-key evil-normal-state-local-map (kbd "C-]")  jump-fun)
  (define-key evil-insert-state-local-map (kbd "C-]") jump-fun)
  (define-key evil-motion-state-local-map (kbd "C-]") jump-fun)

  (when back-fun
    (define-key evil-normal-state-local-map (kbd "C-t")  back-fun)
    (define-key evil-insert-state-local-map (kbd "C-t") back-fun)
    (define-key evil-motion-state-local-map (kbd "C-t") back-fun)
    )

  )

(defun my-join-line ()
  "DOCSTRING"
  (interactive)
  (let (var1 pos-start post-end buf)
    (setq pos-start (region-beginning)   )
    (setq pos-end   (region-end) )
    (setq buf (buffer-substring-no-properties  pos-start pos-end )  )
    (setq buf (s-replace  "\n" "" buf ) )
    (kill-new buf )
    ))




(provide 'xcwen-misc)

;;; xcwen-misc.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (alchemist elixir-mode phpunit phpcbf php-extras php-auto-yasnippets drupal-mode php-mode org-projectile org-present org alert log4e gntp org-download markdown-mode htmlize helm-company helm-c-yasnippet gh-md pos-tip flycheck company yasnippet ac-ispell auto-complete volatile-highlights vi-tilde-fringe spaceline powerline rainbow-delimiters org-bullets lorem-ipsum ido-vertical-mode highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds google-translate flx-ido fancy-battery eyebrowse evil-mc evil-lisp-state smartparens evil-indent-plus evil-exchange evil-escape evil-ediff evil-args define-word clean-aindent-mode ace-jump-helm-line evil-unimpaired spacemacs-theme youdao-dictionary yapfify yaml-mode xterm-color ws-butler wrap-region window-numbering which-key wgrep web-mode web-beautify visual-regexp-steroids uuidgen use-package toc-org tiny tide tagedit solarized-theme smex slim-mode sicp shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe reveal-in-osx-finder restclient restart-emacs rbenv ranger rainbow-mode rainbow-identifiers racket-mode quelpa pyvenv pytest pyenv-mode py-isort pug-mode projectile-rails prodigy popwin pip-requirements persp-mode peep-dired pbcopy paradox osx-trash osx-dictionary origami org-pomodoro org-plus-contrib org-octopress open-junk-file ob-http nodejs-repl neotree mwim multi-term move-text mmm-mode minitest markdown-toc macrostep lua-mode live-py-mode lispy linum-relative link-hint less-css-mode launchctl js2-refactor js-doc ivy-hydra info+ indent-guide impatient-mode ibuffer-projectile hy-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-global hide-comnt help-fns+ helm-github-stars helm-ag graphviz-dot-mode golden-ratio gnuplot glsl-mode gitignore-mode github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gist ggtags flyspell-correct-ivy flycheck-pos-tip flx find-file-in-project fill-column-indicator feature-mode expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-matchit evil-magit evil-iedit-state evil-anzu etags-select eshell-z eshell-prompt-extras esh-help engine-mode emmet-mode elisp-slime-nav dumb-jump dockerfile-mode docker discover-my-major deft cython-mode counsel company-web company-tern company-statistics company-c-headers company-anaconda column-enforce-mode color-identifiers-mode coffee-mode cmake-font-lock clojure-snippets clj-refactor cider-eval-sexp-fu chruby bundler bind-map auto-yasnippet auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-link 4clojure))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
