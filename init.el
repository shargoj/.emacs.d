;; (load-file "/Users/jim/src/cedet/cedet-devel-load.el")

(menu-bar-mode 1)
(tool-bar-mode 0)

(global-auto-revert-mode 1)

(setq-default indent-tabs-mode nil)
(setq tab-width 80)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Important Keybindings ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; When on a mac, ensure sane defaults
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Package Management Stuff ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Import packages and add additional package repositories
(require 'package)
(add-to-list 'package-archives
  '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives 
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(defvar jim/packages '(zenburn-theme rainbow-delimiters python
  projectile popup pkg-info paredit omnisharp noctilux-theme
  multiple-cursors monokai-theme magit helm-themes helm goto-chg
  git-rebase-mode git-commit-mode ghci-completion ghc geiser
  flycheck flex-autopair figlet expand-region evil epl dash
  closure-lint-mode clojure-test-mode clojure-snippets
  clojure-mode cider auto-complete-clang-async
  auto-complete-clang auto-complete ace-jump-mode ac-nrepl
  ac-geiser ack-and-a-half frame-fns frame-cmds ))

(mapc (lambda (package)
        (when (not (package-installed-p package))
          (package-install package)))
      jim/packages)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Make emacs fun to work with ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-nonexistent-file-or-buffer nil)

(ido-mode 1)

(require 'helm)
(require 'helm-config)
(helm-mode 1)
(global-set-key [(meta x)] 'helm-M-x)
(global-set-key [(ctrl x) (ctrl f)] 'helm-find-files)
(global-set-key [(ctrl x) (b)] 'helm-buffers-list)

(global-set-key [(shift meta x)] (lambda ()
                                   (interactive)
                                   (or (boundp 'smex-cache)
                                       (smex-initialize))
                                   (global-set-key [(shift meta x)] 'smex-major-mode-commands)
                                   (smex-major-mode-commands)))

(require 'ace-jump-mode)
(global-set-key (kbd "C-0") 'ace-jump-mode)

(setq ring-bell-function 'ignore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Sane Emacs Defaults ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'multiple-cursors)
(multiple-cursors-mode 1)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)


(require 'auto-complete)
(global-auto-complete-mode t)
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

(require 'flymake)

;;;; Make undo's better
(global-set-key (kbd "C-?") 'undo-tree-mode)

;;;; Always make column-numbers visible
(column-number-mode 1)

;;;; Set up YASnippet
(require 'yasnippet)
(yas-global-mode t)
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

;;;; Enable Undo-Tree for better undo handling
(require 'undo-tree)
(global-undo-tree-mode 1)

;;;; Enable Wrap Region Mode
(require 'wrap-region)
(wrap-region-global-mode 1)
;(wrap-region-add-wrapper "<" ">" nil '(java-mode))

;;;; Enable Expand Region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;;; Enable keychords
(require 'key-chord)
(key-chord-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Language-specifics  ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Clojure
(require 'cider)
(require 'ac-nrepl)

(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-repl-mode))
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'clojure-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-interaction-mode-hook 'set-auto-complete-as-completion-at-point-function)

(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'ac-nrepl-setup)

(add-hook 'clojure-mode-hook 
          (lambda ()
            (local-set-key (kbd "C-c C-e") 'cider-pprint-eval-last-sexp)))
;;; Racket
(setq exec-path
      (append
       exec-path
       '("/usr/texbin" "/usr/bin""/bin" "/usr/sbin" "/sbin" "/usr/local/bin"
         "/Applications/Emacs.app/Contents/MacOS/libexec"
         "/usr/local/i386elfgcc/bin/" "/Users/jim/.cask/bin"
         "/Applications/Emacs.app/Contents/MacOS/bin"
         "/Users/bin/classes/systems/pint-heads/src/utils"
         "/Applications/Racket\\ v6.0/bin")))

(require 'ac-geiser)
(add-hook 'geiser-mode-hook 'ac-geiser-setup)
(add-hook 'geiser-mode-hook 'enable-paredit-mode)
(add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
(add-hook 'geiser-repl-mode-hook 'enable-paredit-mode)
(add-to-list 'ac-modes 'geiser-repl-mode)
(add-to-list 'lisp-mode-hook 'enable-paredit-mode)

(require 's)
(setenv "PATH" (concat (s-join ":" exec-path) (getenv "PATH") ":/sw/bin" ":~/.cabal/bin"))

;;; Haskell
;(require 'ghc-core)
;(autoload 'ghc-init "ghc" nil t)
;(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))

;;; C/C++
(require 'auto-complete-clang)
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key (kbd "C-c o") 'ff-find-other-file)
    (local-set-key (kbd "C-`") 'ac-complete-clang)
    ;; (key-chord-define c++-mode-map "cs" 'cscope-find-this-symbol)
    (semantic-mode 1)))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
(require 'semantic)
(require 'semantic/ia)
(require 'semantic/symref)
;; (global-semantic-idle-completions-mode t)
;; (global-semantic-decoration-mode t)
;; (global-semantic-highlight-func-mode t)
;; (global-semantic-show-unmatched-syntax-mode t)
(require 'cedet)
(global-ede-mode 1)
(require 'xcscope)
(cscope-setup)
(require 'cedet-cscope)
;; (semanticdb-enable-cscope-databases)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Personal e-lisp ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun jim/highlight-todos ()
  (interactive)
  (highlight-regexp "// TODO(jshargo):.*$" 'hi-yellow))
(add-hook 'java-mode-hook #'jim/highlight-todos)

(require 'frame-fns)
(require 'frame-cmds)
(defun jim/set-font-height ()
  "sets the font height to the given number"
  (interactive)
  (let ((font-height (string-to-number (read-from-minibuffer "What height do you want? "))))
    (set-face-attribute 'default nil :height font-height)
    (maximize-frame)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-start 2)
 '(ac-trigger-key "TAB")
 '(column-number-mode t)
 '(custom-safe-themes (quote ("60f04e478dedc16397353fb9f33f0d895ea3dab4f581307fbf0aa2f07e658a40" "a3d519ee30c0aa4b45a277ae41c4fa1ae80e52f04098a2654979b1ab859ab0bf" "73fe242ddbaf2b985689e6ec12e29fab2ecd59f765453ad0e93bc502e6e478d6" "9c26d896b2668f212f39f5b0206c5e3f0ac301611ced8a6f74afe4ee9c7e6311" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "9370aeac615012366188359cb05011aea721c73e1cb194798bc18576025cabeb" "0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "31d3463ee893541ad572c590eb46dcf87103117504099d362eeed1f3347ab18f" "f3ceb7a30f6501c1093bc8ffdf755fe5ddff3a85437deebf3ee8d7bed8991711" "fa189fcf5074d4964f0a53f58d17c7e360bb8f879bd968ec4a56dc36b0013d29" "fc6e906a0e6ead5747ab2e7c5838166f7350b958d82e410257aeeb2820e8a07a" default)))
 '(electric-layout-mode t)
 '(electric-pair-mode t)
 '(flycheck-clang-language-standard "c++11")
 '(geiser-racket-binary "/Applications/Racket v6.0/bin/racket")
 '(global-auto-complete-mode t)
 '(global-flycheck-mode t nil (flycheck))
 '(global-rainbow-delimiters-mode t)
 '(haskell-mode-hook (quote (turn-on-haskell-indentation)))
 '(helm-always-two-windows nil)
 '(helm-buffer-max-length 60)
 '(helm-grep-preferred-ext "*")
 '(helm-split-window-in-side-p t)
 '(help-at-pt-display-when-idle (quote (flymake-overlay)) nil (help-at-pt))
 '(help-at-pt-timer-delay 1.5)
 '(inhibit-startup-screen t)
 '(projectile-global-mode t)
 '(scss-compile-at-save nil)
 '(semantic-mode t)
 '(semantic-symref-auto-expand-results t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#272822" :foreground "#F8F8F2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "apple" :family "Monaco")))))

(load-theme 'monokai)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(desktop-save-mode 1)

(maximize-frame)
