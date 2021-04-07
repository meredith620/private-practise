;; .emacs
;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cl)
(setq default-directory "~/.emacs.d")
;; (add-to-list 'load-path "~/.emacs.d/")

(set-language-environment 'utf-8)
;; gentoo USE=xft to use TrueType
;; Setting English Font
;; (set-face-attribute
;;   'default nil :font "inconsolata 16")

;; Setting English Font
;; (set-face-attribute 'default nil :font "Courier New 12")

;; Chinese Font
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;     (set-fontset-font (frame-parameter nil 'font)
;;                       charset
;;                       (font-spec :family "Microsoft Yahei" :size 12)))
;;==============Display settings==================
(setq default-frame-alist
      '((width . 100)
	(height . 48)
	(mouse-color . "#3CB371")
	(cursor-color . "Pink")
	(background-color . "Black")
	(foreground-color . "White")))
(create-fontset-from-fontset-spec
 (concat
  "-*-Hack-normal-normal-normal-*-16-*-*-*-m-0-fontset-hack,"
  ;; "-*-courier-medium-r-normal-*-18-*-*-*-*-*-fontset-courier,"
  ;"-*-microsoft yahei-medium-r-normal-*-18-*-*-*-*-*-fontset-courier,"
  ;"chinese-gb2312:-*-simsun-medium-r-*-*-10-*-*-*-c-*-gb2312*-*,"
  ))
;; (set-default-font "fontset-courier")
(add-to-list 'default-frame-alist '(font . "fontset-hack"))
(set-face-attribute 'default t :font "fontset-hack")
;; (set-default-font "DejaVu Sans Mono 12")
;; (set-default-font "Liberation Mono 12")
;; (set-default-font "Hack 16")

;;(set-default-font "12x24")
(setq default-frame-alist
      (append
       '((font . "fontset-hack")) default-frame-alist))
;; frontground color
(set-face-foreground 'region "pale green")
;; background color
(set-face-background 'region "dark slate gray")

(setq visible-bell t)
(if (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode)
  (global-linum-mode t))
(column-number-mode t)
(tool-bar-mode -1)
(menu-bar-mode -1) ;; f10 to show menu
(scroll-bar-mode -1)
(setq truncate-partial-width-windows nil)
(display-time-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(auto-image-file-mode)
(auto-compression-mode t)
(setq electric-indent-mode nil)
;; (setq scroll-step 1
;;       ;scroll-margin 3
;;       scroll-conservatively 10000)
(setq require-final-newline t)
;; (delete-selection-mode t)
;; (blink-cursor-mode t)
;; (set-fringe-style -1)
;; (tooltip-mode -1)
(require 'display-line-numbers)

;; enable ShowParenMode
;(setq show-paren-delay 0)
;(setq show-paren-style 'parenthesis)
;(setq show-paren-style 'expression)
;(setq show-paren-style 'mixed)
(show-paren-mode t)
(add-hook 'prog-mode-hook 'highlight-indentation-mode)
(add-hook 'yaml-mode-hook 'highlight-indentation-mode)
;; ======= init pacakge =======
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (require 'init-compat)
;; (require 'init-utils)
;; (require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
;; (require 'init-elpa)      ;; Machinery for installing required packages
;; (require 'init-exec-path) ;; Set up $PATH

;; (require 'init-highlight)

;; ======= highlight mode =======
; highlight symbel
(add-to-list 'load-path "~/.emacs.d/elpa/auto-highlight-symbol-1.55")
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t) ; package: auto-highlight-symbol-mode.el
; highlight line
(add-to-list 'load-path "~/.emacs.d/elpa/hl-line+-20130117.1613")
(require 'hl-line+)
(set-face-background hl-line-face "gray25") ; M-x list-colors-display ,will show a list of colors in a buffer
(toggle-hl-line-when-idle t)   ; package: hi-line+.el
(flash-line-highlight t)
;; (highlight-change-mode t)

;;=========HEX-MODE========
(global-set-key [(f5)] 'hexl-mode)
(global-set-key [(f6)] 'hexl-mode-exit)
(global-set-key [(control f5)] 'hexl-insert-hex-char)
(global-set-key[(f2)](lambda()(interactive)(manual-entry(current-word))))

;; =======table width==============
(global-set-key (kbd "TAB") 'self-insert-command)
;(global-set-key (kbd "TAB") 'tab-to-tab-stop)
(setq-default indent-tabs-mode nil)  
(setq default-tab-width 5)
(setq tab-width 5)
(setq tab-stop-list ())
;; (global-set-key [(f11)] 'toggle-truncate-lines)
;;============template=================
;; (add-to-list 'load-path "~/.emacs.d/template")
;; (require 'template)
;; (template-initialize)

;;========== package manager ==========
(setq package-archives '(("cn-gnu" . "https://elpa.emacs-china.org/gnu/")
                         ;; ("cn-melpa-stable" . "http://elpa.emacs-china.org/melpa-stable/")
                         ;; ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/") 
                         ;; ("melpa" . "https://melpa.org/packages/")
                         
                         ))

(defun my-paren-mode()
  "my lisp mode hook"
  (interactive)
  (paredit-mode)
  (rainbow-delimiters-mode)
  ;; (local-set-key "\C-c\C-q" 'slime-close-all-parens-in-sexp)
  )
;;============sawfish mode=============
(add-to-list 'load-path "~/.emacs.d/sawfish")
(require 'sawfish)
(add-hook 'sawfish-mode-hook #'my-paren-mode)

;; ---- switch-window ----
(global-set-key (kbd "C-x p") 'switch-window)
;; (setq switch-window-shortcut-style 'qwerty)
;; (setq switch-window-input-style 'minibuffer)
;;============scheme==================
(require 'cmuscheme)
 (setq scheme-program-name ;; "petite"
       "racket")
(add-hook 'scheme-mode-hook #'my-paren-mode)
(add-hook 'scheme-mode-hook 'my-auto-complete)

;;============slime mode===============
(add-to-list 'load-path "~/.emacs.d/elpa/slime-20130526.820")
;; (setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-lisp-implementations ; to choose "\M-- \M-x slime"
      '((sbcl ("/usr/bin/sbcl") :coding-system utf-8-unix)    ;(NAME ("/path/to/imp" "--args") :coding-system)
        (clisp ("/usr/bin/clisp") :coding-system utf-8-unix)))
(require 'slime)
(slime-setup)
;; (require 'slime-autoloads)
;; (slime-setup '(slime-fancy))

(add-hook 'lisp-mode-hook 'my-paren-mode)
(add-hook 'lisp-mode-hook 'my-auto-complete)
(add-hook 'emacs-lisp-mode-hook 'my-paren-mode)
(add-hook 'emacs-lisp-mode-hook 'my-auto-complete)
          
;;============cc mode=========================
;emacs search path
(add-to-list 'load-path "/home/meredith/.emacs.d/cc-mode")

;; (add-hook 'c-mode-common-hook ( lambda() ( c-set-style "k&r" ) ) ) ;;c default format
;; (add-hook 'c++-mode-common-hook ( lambda() ( c-set-style "k&r" ) ) ) ;;c++ default format

(defun my-hide-show ()
  "my c/c++ hide show hook"
  (interactive)
  (hs-minor-mode)		  ;;hide show codes function            
  (local-set-key "\C-c\t" 'complete-symbol)				
  (setq mslk-c++-key (make-keymap))
  (local-set-key "\C-m" mslk-c++-key)				;(local-set-key "\C-m" 'newline-and-indent)
  (define-key mslk-c++-key "\C-c" 'complete-symbol)
  (define-key mslk-c++-key "\C-o" 'hs-hide-all)
  (define-key mslk-c++-key "\C-p" 'hs-show-all)
  (define-key mslk-c++-key "\C-h" 'hs-hide-block)
  (define-key mslk-c++-key "\C-u" 'hs-show-block)
  (define-key mslk-c++-key "\C-l" 'hs-hide-level)
  (define-key mslk-c++-key "\C-m" 'hs-toggle-hiding))

;; (defun my-semantic-mode ()
;;   "my semantic mode config"
;;   (interactive)
;;   ;; (semantic-load-enable-minimum-features)           
;;   (semantic-load-enable-code-helpers)               
;;   ;; (semantic-load-enable-guady-code-helpers)         
;;   ;; (semantic-load-enable-excessive-code-helpers)     
;;   (semantic-load-enable-semantic-debugging-helpers))

(defun mc-mode-hook ()
  "my c/c++ mode hook"
  (interactive)
  ( c-set-style "k&r" )
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 5)
  ;; (global-set-key [(f1)]  'manual-entry)
  ;; (global-set-key [(control f1)]) 'info)
  (load "which-func")
  (which-func-mode 1)
  (my-hide-show)
  ;; (delete (assoc 'which-func-mode mode-line-format) mode-line-format)
  ;; (setq which-func-header-line-format
  ;;       '(which-func-mode
  ;;         ("" which-func-format
  ;;          )))
  ;; (defadvice which-func-ff-hook (after header-line activate)
  ;;   (when which-func-mode
  ;;     (delete (assoc 'which-func-mode mode-line-format) mode-line-format)
  ;;     (setq header-line-format which-func-header-line-format)))
  )
(add-hook 'c++-mode-hook 'mc-mode-hook)
(add-hook 'c-mode-hook 'mc-mode-hook)
(add-hook 'c-mode-hook 'my-auto-complete)
(add-hook 'c++-mode-hook 'my-auto-complete)

;;============compile===========================
(defun quick-compile ()
  "A quick compile funciton for C++"
  (interactive)
  (compile (concat "g++ " (buffer-name (current-buffer)) " -g -pg"))
  )
;(global-set-key [(f7)] 'quick-compile)
(global-set-key [(f7)] 'compile)
(global-set-key [(f9)] 'gdb)
(setq gdb-many-windows t)

;;========sematic-mode===========================
;; (semantic-mode)
;; (add-hook 'semantic-mode-hook
;;           ;(semantic-idle-scheduler-mode)
;;           ;(semanticdb-minor-mode)
;;           ;(semanticdb-load-ebrowse-caches)
;;           ;(imenu)
;;           ;(semantic-idle-summary-mode)
;;           (senator-minor-mode)
;;           ;(semantic-mru-bookmark-mode)
;;           (semantic-stickyfunc-mode)
;;           (semantic-decoration-mode)
;;           ;(semantic-idle-completions-mode)
;;           (semantic-highlight-func-mode)
;;           (semantic-idle-tag-highlight-mode)
;;           (semantic-decoration-on-*-members)
;;           (semantic-highlight-edits-mode)
;;           ;(semantic-show-unmatched-syntax-mode)
;;           ;(semantic-show-parser-state-mode)
;;           )

;;=========auto-complete==================
;; (add-to-list 'load-path "~/.emacs.d/elpa/popup-20150116.1223/")
;; (add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4/")
(defun my-auto-complete ()
  "my auto-complete config"
  (interactive)
  (require 'auto-complete-config)
  (add-to-list 'ac-dictionary-directories
               "~/.emacs.d/elpa/auto-complete-1.4/dict")
  (ac-config-default)
  (setq ac-fuzzy-enable t)
  ;; (setq ac-auto-start nil)
  ;; (define-key ac-mode-map  (kbd "M-j") 'auto-complete)
)

;;======== clojure-mode ===================
(add-hook 'clojure-mode-hook #'auto-highlight-symbol-mode)
(add-hook 'clojure-mode-hook #'my-paren-mode)
(add-hook 'clojure-mode-hook #'cider-mode)
;; ; send expr to nrepl instead of default to minibuffer
;; (defun my-interactive-eval-to-repl (form)
;;   (let ((buffer nrepl-nrepl-buffer))
;;   (nrepl-send-string form (nrepl-handler buffer) nrepl-buffer-ns)))
;; (defun my-eval-last-expression-to-repl ()
;;   (interactive)
;;   (my-interactive-eval-to-repl (nrepl-last-expression)))
;; (defun eval-in-nrepl ()
;;   (interactive)
;;   (let ((exp (nrepl-last-expression)))
;;     (with-current-buffer (nrepl-current-repl-buffer)
;;       (nrepl-replace-input exp)
;;       (nrepl-return))))
;; (define-key nrepl-interaction-mode-map "\C-x \C-e" 'eval-in-nrepl)
;; (eval-after-load 'nrepl
;;   '(progn 
;;      (define-key nrepl-interaction-mode-map (kbd "C-x C-e") 'my-eval-last-expression-to-repl)))

; ----- company -----
;; (add-hook 'cider-mode-hook #'paredit-mode)
(add-hook 'cider-mode-hook #'company-mode)
;; (add-hook 'cider-mode-hook #'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook #'my-paren-mode)
(add-hook 'cider-repl-mode-hook #'company-mode)
;; (setq company-idle-delay nil) ; never start completions automatically
;; (global-set-key (kbd "C-tab") #'company-complete) ; use meta+tab, aka C-M-i, as manual trigger
(setq cider-completion-annotations-include-ns t)
(setq cider-annotate-completion-candidates t)

(add-hook 'cider-mode-hook #'eldoc-mode)
(setq cider-lein-parameters "repl :headless :host localhost")
(setq cider-auto-mode nil)
(setq nrepl-log-messages t)
(setq cider-prefer-local-resources t)
;(setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-show-error-buffer 'only-in-repl)
(setq cider-stacktrace-default-filters '(tooling dup))
(setq cider-stacktrace-fill-column 80)
(setq nrepl-buffer-name-show-port t)
(setq cider-repl-result-prefix ";; => ")
;(setq cider-known-endpoints '(("host-a" "10.10.10.1" "7888") ("host-b" "7888")))
(setq cider-test-show-report-on-success t)

;;========python-mode============================
;; (add-to-list 'load-path "/home/meredith/.emacs.d/python-mode.el-6.0.5/") 
;; (setq py-install-directory "/home/meredith/.emacs.d/python-mode.el-6.0.5/")
;; (require 'python-mode)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq-default python-indent 4)            
            (setq-default py-indent-offset 4)
            (setq py-guess-indent-offset 4)
            (my-hide-show)
            ))
; jedi
(add-to-list 'load-path "~/.emacs.d/elpa/epc-20140609.2234")
(add-to-list 'load-path "~/.emacs.d/elpa/jedi-20150308.517")
(autoload 'jedi:setup "jedi" nil t)
(setq jedi:complete-on-dot t)
(setq jedi:environment-root "~/opt/vpy")
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'my-auto-complete)

;; ===========java-mod=========================
(defun java-hook ()
  "my c/c++ mode hook"
  (interactive)
  (setq indent-tabs-mode nil)
  (load "which-func")
  (which-func-mode 1)
  (my-hide-show))
(add-hook 'java-mode-hook 'java-hook)
; ----- lsp - java ----
;; (add-to-list 'load-path "~/.emacs.d/elpa/lsp-mode-4.2")
;; (add-to-list 'load-path "~/.emacs.d/elpa/flycheck-31")
;; (add-to-list 'load-path "~/.emacs.d/elpa/dash-20170712.1927")
;; (add-to-list 'load-path "~/.emacs.d/elpa/dash-functional-2.14.1")
;; (add-to-list 'load-path "~/.emacs.d/elpa/markdown-mode-20130328.918")
(add-to-list 'load-path "~/.emacs.d/lsp-ui/")
(with-eval-after-load 'lsp-mode
  (require 'lsp-intellij)
  (require 'lsp-ui)
  (require 'company-lsp)
  (add-hook 'java-mode-hook #'lsp-intellij-enable)
  (push 'company-lsp company-backends)
  (push 'java-mode company-global-modes))
;; (require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'lsp-after-open-hook #'lsp-ui-mode)
;; (require 'company-lsp)
(setq company-lsp-enable-snippet t
      company-lsp-cache-candidates t)
;; (push 'company-lsp company-backends)
;; (push 'java-mode company-global-modes)
;;========TRAMP====================================
(require 'tramp)
;; (add-to-list 'tramp-default-proxies-alist
;;              '("\\." nil "/ssh:bird@bastion.your.domain#port:"))
;; (add-to-list 'tramp-default-proxies-alist
;;              '("\\.your\\.domain\\'" nil nil))
;; ---another host called 'jump.your.domain', which is the only one in your local domain who is allowed connecting 'bastion.your.domain'---
;; (add-to-list 'tramp-default-proxies-alist
;;                   '("\\`bastion\\.your\\.domain\\'"
;;                     "\\`bird\\'"
;;                     "/ssh:jump.your.domain#port:"))

;;========git-mode===================
(add-to-list 'load-path "~/.emacs.d/git")
(require 'git)
(require 'git-blame)

;;========org-mode=================================
(add-hook 'org-mode-hook (lambda ()
                           (setq truncate-lines nil)))
(setq org-log-done 'time)
(setq org-log-done 'note)
(setq org-src-fontify-natively t)
;; ;; active Babel languages
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((sh .t)
;;    (python .t)
;;    (emacs-lisp .t)
;;    ))
                                        ; export html with custom inline css
(defun my-inline-custom-css-hook ()
  "insert custom inline css content into org export"
  (let* ( (working-path (ignore-errors (file-name-directory (buffer-file-name))))
          (custom-css (concat working-path "style.css"))
          (custom-css-flag (and (not (null working-path)) (not (null (file-exists-p custom-css)))))
          (target-css (if custom-css-flag
                          custom-css
                        "~/.emacs.d/org-style.css")))
    ;; (setq org-export-html-style-include-default nil)
    (setq org-html-head (concat
                         "<style type=\"text/css\">\n"
                         "<!--/*--><![CDATA[/*><!--*/\n"
                         (with-temp-buffer
                           (insert-file-contents target-css)
                           (buffer-string))
                         "/*]]>*/-->\n"
                         "</style>\n"))))
(add-hook 'org-mode-hook 'my-inline-custom-css-hook)
;; (add-hook 'org-mode-hook 'org-export-as-s5)
(setq org-default-notes-file "~/.note/gtd.org")
(setq org-archive-location "%s_archive::date-tree")
(setq org-agenda-files (list org-default-notes-file))
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c C-x C-r") 'org-clock-report)

;; (setq org-todo-keywords
;;     '((sequence "TODO(t!)" "SOMEDAY(s)" "|" "DONE(d!)" "CANCELED(c @/!)")))
(defvar org-agenda-dir "" "gtd org files location")
(setq-default org-agenda-dir "~/.note/")
(setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
(setq org-agenda-file-task (expand-file-name "task.org" org-agenda-dir))
(setq org-agenda-file-calendar (expand-file-name "calendar.org" org-agenda-dir))
(setq org-agenda-file-finished (expand-file-name "finished.org" org-agenda-dir))
(setq org-agenda-file-canceled (expand-file-name "canceled.org" org-agenda-dir))
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-agenda-file-task "Work")
         "* TODO [#B] %?\n  %i\n" :empty-lines 1)
        ("l" "Tolearn" entry (file+headline org-agenda-file-task "Learning")
         "* TODO [#B] %?\n  %i\n" :empty-lines 1)
        ("h" "Toplay" entry (file+headline org-agenda-file-task "Hobbies")
         "* TODO [#C] %?\n  %i\n" :empty-lines 1)
        ("o" "Todo_others" entry (file+headline org-agenda-file-task "Others")
         "* TODO [#C] %?\n  %i\n" :empty-lines 1)
        ("n" "notes" entry (file+headline org-agenda-file-note "Quick notes")
         "* %?\n  %i\n %U" :empty-lines 1)
        ("i" "ideas" entry (file+headline org-agenda-file-note "Quick ideas")
         "* %?\n  %i\n %U" :empty-lines 1)))

(add-to-list 'load-path "~/.emacs.d/org-s5")
(require 'org-s5)
(setq org-re-reveal-root "file:///home/lvliang/downloads/emacs-present/reveal.js")
;; (require 'org-export-as-s5)
;;========markdown-mode============================
(add-to-list 'load-path "~/.emacs.d/elpa/markdown-mode-20130328.918")
(require 'markdown-mode)
;; (autoload 'markdown-mode "markdown-mode"
;;    "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))

;;========cscope===================================
(add-to-list 'load-path "~/.emacs.d/cscope")
(require 'xcscope)
;;==================================================
;;==========w3m-mode================================
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-w3m")
(require 'w3m-load)
(setq w3m-command-arguments '("-cookie" "-F"))
(setq w3m-use-cookies t)
(setq w3m-home-page "https://www.google.com/ncr")
(setq w3m-default-display-inline-image t) 
(setq w3m-default-toggle-inline-images t)

(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(autoload 'w3m-search "w3m-search" "Search words using emacs-w3m." t)
;;====================================================================

;;==================== graphviz mode ==============================
;; (load-file "~/.emacs.d/elpa/graphviz-dot-mode-20120821.1835/graphviz-dot-mode.el")

;;============for latex========================================
;; (require 'org-latex)

;; ;;============org-html5present=========================
;; (add-to-list 'load-path "~/.emacs.d/org-html5")
;; (require 'org-html5presentation)

;;=====================for sliders ============================
;; (add-to-list 'load-path "~/.emacs.d/slide")
;; (require 'epresent)
;; (require 'org-html5presentation)
;;=============================================================

;;==================================================
;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)
(add-hook 'text-mode-hook
  (function
   (lambda ()
     (setq tab-width 5)
     (define-key text-mode-map "\C-i" 'self-insert-command)
     )))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("~/.note/notes.org" "~/.note/task.org"))
 '(package-selected-packages
   '(org-re-reveal sql-indent nlinum csv-mode highlight-indentation flycheck-yamllint dockerfile-mode company-lsp cider ssh-config-mode lua-mode magit cider-decompile javap-mode yaml-mode scala-mode switch-window slime rainbow-delimiters paredit markdown-mode jedi hl-line+ graphviz-dot-mode company auto-highlight-symbol))
 '(truncate-partial-width-windows nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(switch-window-label ((t (:inherit font-lock-builtin-face :slant normal :weight normal :height 960 :width normal :foundry "TMC " :family "Microsoft Yahei")))))
