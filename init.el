;;; package --- Jim Shargo's emacs init.el

;;; Commentary:
;; Things are roughly ordered by usage/language.

;;; Code:

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
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not (package-installed-p 'use-package))
  ;; This is likely the first time we're running emacs in a new environment.
  (package-refresh-contents)
  (package-install 'use-package))

(setq
 exec-path
 (append
  exec-path
  '("/usr/local/bin" "/Users/jim/.cargo/bin"
    "~/.cabal/bin" "/usr/texbin" "/usr/bin" "/bin"
    "/usr/sbin" "q/sbin"
    "/Applications/Emacs.app/Contents/MacOS/libexec"
    "/Users/jim/.cask/bin"
    "/Applications/Emacs.app/Contents/MacOS/bin"
    "/Applications/Racket\\ v6.1/bin")))

(require 's)
(setenv "PATH" (concat (s-join ":" exec-path) (getenv "PATH") ":/sw/bin" ":~/.cabal/bin"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Make emacs fun to work with ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-nonexistent-file-or-buffer nil)
(setq ring-bell-function 'ignore)

(ido-mode 1)

(use-package helm
  :ensure t
  :init (helm-mode 1))

(use-package helm-config)
(use-package helm-semantic)

(global-set-key [(meta x)] 'helm-M-x)
(global-set-key [(ctrl x) (ctrl f)] 'helm-find-files)
(global-set-key [(ctrl x) (b)] 'helm-buffers-list)
(define-key helm-map (kbd "C-z") 'helm-execute-persistent-action)

(use-package ace-jump-mode
  :ensure t
  :bind (("C-0" . 'ace-jump-mode)
         ("C-." . 'ace-jump-mode)))

(use-package highlight-indentation :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Sane Emacs Defaults ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; Enable line highlighting
(global-hl-line-mode)

;;;; Always make column-numbers visible
(column-number-mode 1)

(use-package multiple-cursors
  :ensure t
  :init (multiple-cursors-mode 1)
  :bind (("C-S-c C-S-c" . 'mc/edit-lines)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)
         ("C-c C-<" . 'mc/mark-all-like-this)))

(use-package flymake :ensure t)

;;;; Set up YASnippet
(use-package yasnippet
  :ensure t
  :init (yas-global-mode t))

;;;; Enable Undo-Tree for better undo handling
(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode 1))

;;;; Enable Expand Region
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

;;;; Enable keychords
(use-package key-chord
  :ensure t
  :init (key-chord-mode t))

(use-package string-inflection
  :ensure t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (if (eq system-type 'darwin)
      (exec-path-from-shell-initialize)))

(use-package flycheck; On-the-fly syntax checking
  :ensure t
  :bind (("C-c t f" . flycheck-mode))
  :init (global-flycheck-mode)
  :config
  (setq ;; flycheck-standard-error-navigation nil
   flycheck-display-errors-function
   #'flycheck-display-error-messages-unless-error-list)
  :diminish (flycheck-mode . " Ⓢ"))

(use-package flycheck-inline
  :ensure t
  :after (flycheck)
  :config (flycheck-inline-mode))

(use-package company                    ; Graphical (auto-)completion
  :ensure t
  :diminish company-mode
  :init (global-company-mode)
  :config
  (setq company-tooltip-align-annotations t
        company-tooltip-flip-when-above t
        ;; Easy navigation to candidates with M-<n>
        company-show-numbers t)
  :diminish company-mode)

(use-package company-quickhelp          ; Show help in tooltip
  :disabled t                           ; M-h clashes with mark-paragraph
  :ensure t
  :after company
  :config (company-quickhelp-mode))

(use-package company-math               ; Completion for Math symbols
  :ensure t
  :after company
  :config
  ;; Add backends for math characters
  (add-to-list 'company-backends 'company-math-symbols-unicode)
  (add-to-list 'company-backends 'company-math-symbols-latex))

(use-package helm-company               ; Helm frontend for company
  :ensure t
  :defer t
  :bind (:map company-mode-map
              ([remap complete-symbol] . helm-company)
              ([remap completion-at-point] . helm-company)
              :map company-active-map
              ("C-:" . helm-company)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Language-specifics  ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Web / JS / PHP
(use-package web-mode :ensure t)

;;; Lispy languages in general
(use-package paredit
  :ensure t
  :init
  (add-to-list 'lisp-mode-hook 'enable-paredit-mode))

;;; Rust
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")
(use-package cargo
  :ensure t
  :init (add-hook 'rust-mode-hook #'cargo-minor-mode)
  :diminish (racer-mode . "ⓡ"))
(use-package racer
  :ensure t
  :init (add-hook 'rust-mode-hook #'racer-mode)
  :diminish)
(use-package flycheck-rust
  :ensure t
  :after (rust-mode flycheck cargo)
  :init
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

;;; Clojure
;; (require 'cider)
;; (require 'cider-test)
;; (require 'ac-cider)

;; (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
;; (add-hook 'cider-interaction-mode-hook 'ac-cider-setup)
;; (add-hook 'clojure-mode-hook 'ac-cider-setup)

;; (add-hook 'clojure-mode-hook 'enable-paredit-mode)
;; (add-hook 'cider-interaction-mode-hook 'enable-paredit-mode)

;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'cider-repl-mode))
;; (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq completion-at-point-functions '(auto-complete)))
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'clojure-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'clojure-mode-hook 'cider-turn-on-eldoc-mode)
;; (add-hook 'cider-interaction-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; (defun jim/cider-test-is-test-ns (ns)
;;   (let ((suffix "-test"))
;;     (string-match (rx-to-string `(: ,suffix eos) t) ns)))

;; (defun jim/cider-test-impl-ns-fn (ns)
;;   (when ns
;;     (let ((suffix "-test"))
;;       (if (string-match (rx-to-string `(: ,suffix eos) t) ns)
;;           (s-replace suffix "" ns)
;;         ns))))

;; (defun jim/cider-test-jump-around ()
;;   (interactive)
;;   (let ((ns (cider-current-ns)))
;;     (switch-to-buffer
;;      (cider-find-buffer
;;       (if (jim/cider-test-is-test-ns ns)
;;           (jim/cider-test-impl-ns-fn ns)
;;         (cider-test-default-test-ns-fn ns))))))

;; (defun jim/clojure-keybinds ()
;;   (interactive)
;;   (define-key cider-mode-map (kbd "C-c C-e") 'cider-pprint-eval-last-sexp)
;;   (define-key cider-mode-map (kbd "C-c C-t") 'jim/cider-test-jump-around)
;;   (define-key cider-mode-map (kbd "C-c M-,") 'cider-test-run-tests))

;; (add-hook 'clojure-mode-hook 'jim/clojure-keybinds)

;;; Racket
(use-package racket-mode :ensure t)

;;; Haskell
(setq haskell-stylish-on-save t)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(setq inferior-haskell-find-project-root nil)

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(eval-after-load 'haskell-mode '(progn
                                  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
                                  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
                                  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
                                  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
                                  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
                                  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
                                  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))
(eval-after-load 'haskell-cabal '(progn
                                   (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
                                   (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-ode-clear)
                                   (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
                                   (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Custom Set Variables  ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-start 1)
 '(ac-trigger-key "TAB")
 '(cider-stacktrace-default-filters (quote (tooling dup nrepl)))
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" "bd7b7c5df1174796deefce5debc2d976b264585d51852c962362be83932873d9" default)))
 '(deft-directory "/Users/jim/notes/")
 '(deft-extension "org")
 '(deft-text-mode (quote org-mode))
 '(deft-use-filename-as-title t)
 '(electric-layout-mode nil)
 '(electric-pair-mode t)
 '(fci-rule-color "#383838")
 '(flycheck-clang-language-standard "c++11")
 '(geiser-racket-binary "/Applications/Racket v6.1/bin/racket")
 '(global-flycheck-mode t nil (flycheck))
 '(global-rainbow-delimiters-mode t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote stack-ghci))
 '(helm-always-two-windows nil)
 '(helm-buffer-max-length 60)
 '(helm-grep-preferred-ext "*")
 '(helm-split-window-inside-p t)
 '(help-at-pt-display-when-idle (quote (flymake-overlay)) nil (help-at-pt))
 '(help-at-pt-timer-delay 1.5)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(package-selected-packages
   (quote
    (highlight-indentation docker-compose-mode web-mode clj-refactor cljr-helm company-php flymake-php php-auto-yasnippets php-eldoc php-mode php-refactor-mode php-runtime php-scratch sesman cider cider-eval-sexp-fu helm-cider helm-cider-history tide tss typescript-mode json-mode json-reformat company-tern tern string-inflection flycheck-inline flymake-inline rainbow-delimiters exec-path-from-shell helm-company auto-yasnippet yasnippet-classic-snippets yasnippet-snippets cargo flycheck-rust flymake-rust racer rust-mode rust-playground rustic paredit omnisharp noctilux-theme monokai-theme magit key-chord js2-refactor helm-themes helm-projectile helm-proc helm-hoogle google-this git-commit-mode ghc frame-cmds flycheck-haskell flex-autopair expand-region evil esup ebal diminish cyberpunk-theme company-quickhelp cmake-project cmake-mode cmake-ide closure-lint-mode clojure-snippets ack-and-a-half ace-jump-mode)))
 '(projectile-global-mode t)
 '(python-indent-offset 2)
 '(racket-mode-pretty-lambda t)
 '(racket-program "/Applications/Racket v6.1/bin/racket")
 '(raco-program "/Applications/Racket v6.1/bin/raco")
 '(scss-compile-at-save nil)
 '(semantic-mode t)
 '(semantic-symref-auto-expand-results t)
 '(tab-width 2))

;;; C/C++

(use-package semantic :ensure t
  :init
  (global-semantic-idle-completions-mode t)
  (global-semantic-decoration-mode t)
  (global-semantic-highlight-func-mode t))

(use-package cedet
  :ensure t
  :init (global-ede-mode 1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Personal e-lisp ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun jim/go-to-init ()
  (interactive)
  (find-file user-init-file))

(defun jim/highlight-todos ()
  (interactive)
  (highlight-regexp "// TODO(jshargo):.*$" 'hi-yellow))
(add-hook 'java-mode-hook #'jim/highlight-todos)

(use-package frame-fns)
(use-package frame-cmds)
(defun jim/set-font-height ()
  "sets the font height to the given number"
  (interactive)
  (let ((font-height (string-to-number (read-from-minibuffer "What height do you want? "))))
    (set-face-attribute 'default nil :height font-height)
    (maximize-frame)))

(defun jim/eshell/clear ()
  "clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Final Setup  ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package monokai-theme
  :ensure t
  :init (load-theme 'monokai))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(desktop-save-mode 1)

(put 'erase-buffer 'disabled nil)

;; (set-face-attribute 'default t :font "Source Code Pro for Powerline")
;; (set-frame-font "Source Code Pro for Powerline" nil t)

(provide 'init)

;;; init.el ends here
