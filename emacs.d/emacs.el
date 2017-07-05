
(fset 'yes-or-no-p 'y-or-n-p)

(defun save-all ()
(interactive)
(save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))
;; (package-initialize)
;; (package-refresh-contents)

(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

      ;;(require 'use-package)
 (eval-when-compile
   (require 'use-package))

(setq user-full-name "Shourai"
user-mail-address "mail@shourai.net")

(setq-default indent-tabs-mode nil)
(setq tab-width 4)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq default-frame-alist
  '(
    (top . 100)
    (left . 100)
    (width . 130) ; character
    (height . 40) ; lines
    ))

(setq inhibit-startup-message t)

(use-package which-key
   :ensure t 
   :defer 2 
   :config
   (which-key-mode))

(use-package nlinum-relative
:ensure t
:config
(global-nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0.5))

(use-package solarized-theme 
:ensure t
:init
(load-theme 'solarized-light t))

(global-hl-line-mode 1) 
;;     (set-face-background 'hl-line "#2b2f31")

(set-face-attribute 'region nil :background "#676767")

(setq-default fill-column 80)

(add-hook 'text-mode-hook '(lambda ()
                               (auto-fill-mode 1)))

(add-hook 'LaTeX-mode-hook '(lambda ()
                              (auto-fill-mode 1)))

(use-package rainbow-delimiters
:ensure t
:defer t 
:config )

(use-package highlight-parentheses
:ensure t
:defer t 
:config )

(use-package undo-tree
:ensure t
:defer t 
:config
(global-undo-tree-mode t))

(use-package helm
:ensure t
:defer 1
:bind (("M-x" . helm-M-x)
       ("C-x C-b" . helm-mini)
       ("C-x C-f" . helm-find-files)
       ("M-y" . helm-show-kill-ring))
:config
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
(setq helm-buffers-fuzzy-matching t
  helm-recentf-fuzzy-match    t))

(use-package company
:ensure t
:defer 10
:init
(add-hook 'after-init-hook 'global-company-mode))

(use-package company-quickhelp
:ensure t
:defer 10
:config
(company-quickhelp-mode 1))

(use-package yasnippet
:ensure t
:defer 10
:config
(yas-global-mode 1))

(use-package smartparens
:ensure t
:defer 10
:bind (("TAB" . sp-up-sexp))
:init
(add-hook 'python-mode-hook #'smartparens-mode)
(add-hook 'LaTeX-mode-hook #'smartparens-mode)
:config
(require 'smartparens-latex))

(use-package evil
:ensure t
:bind (("C-z" . turn-on-evil-mode)
("C-x C-z" . turn-off-evil-mode))
:init
(setq evil-want-C-u-scroll t)
:config
(evil-mode t))

(add-hook 'focus-in-hook 'normal-mode)

(use-package evil-escape
:ensure t
:config
(evil-escape-mode t))

(use-package evil-numbers
:ensure t
:bind ("C-c +" . evil-numbers/inc-at-pt)
("C-c -" . evil-numbers/dec-at-pt))

(use-package evil-surround
:ensure t
:defer 10
:config
(global-evil-surround-mode 1))

(use-package evil-mc
:ensure t
:defer t)

(use-package avy
  :ensure t
  :defer t
  :bind (("C-:" . avy-goto-char)
  ("C-'" . avy-goto-char-2)
  ("M-g f" . avy-goto-line)
  ("M-g w" . avy-goto-word-1)
  ("M-g e" . avy-goto-word-0)))

(use-package expand-region
  :ensure t
  :defer t
  :bind ("C-=" . er/expand-region))

(use-package tex
:ensure auctex
:mode ("\\.tex\\'" . LaTeX-mode)
:interpreter ("LatexMk" . LaTeX-mode)
:config
;; enable parse on load and save
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;; autosave before compiling
(setq TeX-save-query nil)
;; let AUCTeX query for master file name
(setq-default TeX-master nil))

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin"))
(setq exec-path (append exec-path '("/Library/TeX/texbin")))

(use-package auctex-latexmk
:ensure t
:defer 10
:init (add-hook 'LaTeX-mode-hook 'auctex-latexmk-setup)
:config
;; Let LatexMk to pass the -pdf flag when TeX-PDF-mode is active 
(setq auctex-latexmk-inherit-TeX-PDF-mode t))

(use-package company-auctex
  :ensure t
  :defer 5
  :init (add-hook 'LaTeX-mode-hook 'company-auctex-init))

(setq LaTeX-math-list())
(add-to-list 'LaTeX-math-list '(?1 "partial" "Misc Symbol" 8706))

(setq TeX-electric-sub-and-superscript 1)
;; (setq TeX-electric-math (cons "$" "$"))

(use-package elpy
:ensure t
:after python
;:mode ("\\.py\\'" . python-mode)
;:interpreter ("python" . python-mode)
:config
(elpy-enable))

(setq python-shell-interpreter "python3")

(setq elpy-rpc-python-command "python3")

(setq org-confirm-babel-evaluate nil
      org-src-fontify-natively t
      org-src-tab-acts-natively t)

(setq org-html-validation-link nil)

(use-package magit
  :ensure t
  :defer t
  :bind (("C-x g" . magit-status))
  :config  (require 'evil-magit))

(use-package evil-magit
  :ensure t
  :defer t)

(use-package ledger-mode
  :ensure t
  :defer t)

(with-eval-after-load 'ledger-mode
  ;(define-key ledger-mode-map (kbd "C-c $") "€")
  (define-key ledger-mode-map (kbd "C-c $") (lambda () (interactive) (insert "€")))
  (define-key ledger-mode-map (kbd "C-c c") 'ledger-mode-clean-buffer))
