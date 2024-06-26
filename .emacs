;;; Emacs --- Init file
;;; Commentary:
;;; TODO:
;;; csproj update
;;; dependency checker: aspell/hunspell
;;; Modeline
;;; counsel-flymake
;;; counsel-rgrep
;;; Add a sane initialization to tree-sitter-indent
;;; Fix damn temp/backup files!

;;; Code:

(add-to-list 'command-switch-alist '("-exwm" . my-exwm-hook))

;; Path
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'exec-path "/usr/local/bin")
(native-compile-async load-path)

(require 'joes-utils)
(require 'joes-theme)
(require 'joes-keybindings)
(require 'joes-hooks)
(require 'joes-packages-manager)

;; -- Package Manager
;;(package-refresh-contents)
(package-install-selected-packages t)

;; -- Keybindings
(when (not (eq system-type 'darwin))
	(simulate-command-key))

(set-common-keybindings)

;; Global variables
;; -- General
(setq-default display-line-numbers-grow-only 1)
(setq-default python-shell-interpreter "/usr/bin/python3")
(setq-default ring-bell-function 'blink-minibuffer)
(setq-default scroll-conservatively 10000)
(setq-default scroll-step 1)
(setq-default lisp-indent-offset 4)
(setq-default tab-width 4)
(setq-default visible-bell nil)
(setq-default visual-line-fringe-indicators 'left-curly-arrow right-curly-arrow)
(setq-default project-file-extensions (delete-dups (append project-file-extensions '("cs" "go" "py" "tex"))))
(setq-default ispell-complete-word-dict (file-truename "~/.words"))
;; Prefer Hunspell. If not, whatever is found.
(setq-default ispell-program-name (or (executable-find "hunspell") ispell-program-name))
(setq-default elisp-flymake-byte-compile-load-path (append elisp-flymake-byte-compile-load-path load-path))
(put 'narrow-to-region 'disabled nil)
(apply-flymake-theme)
(apply-default-theme-faces)

;; Backup configuration
(setq backup-directory-alist `((".*" . "~/.backups")))
(setq auto-save-file-name-transforms `((".*" "~/.backups" t)))

;; Local envinronment configuration
(ignore-errors (load-file "~/.emacs-local.el"))
(setq recentf-save-file "~/.emacs-recentf")

;; Minor modes globally unloaded
(menu-bar-mode 0)
(ignore-errors (scroll-bar-mode 0))
(ignore-errors (tool-bar-mode 0))

;; Global hooks
(add-hook 'prog-mode-hook 'my-prog-mode-hook 10)
(add-hook 'text-mode-hook 'my-text-mode-hook 10)
;;(add-hook 'before-save-hook 'my-save-hook)

;; Default minor modes globally pre-loaded
(column-number-mode 1)
(global-visual-line-mode 1)
(show-paren-mode 1)
(global-hl-line-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(delete-selection-mode 1)
(cua-selection-mode 1)
(fringe-mode '(8 . 0))

;; Major modes hooks
(add-to-list 'auto-mode-alist '("\\.log$" . logview-mode))
(add-to-list 'auto-mode-alist '("\\.pdf$" . pdf-tools-install))
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)
(add-hook 'ediff-mode-hook 'my-ediff-mode-hook)
(add-hook 'python-mode-hook 'my-python-mode-hook)
(add-hook 'latex-mode-hook 'my-latex-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-hook)
(add-hook 'c++-mode-hook 'my-cpp-mode-hook)

;; -- External packages configuration and modes

(eval-when-compile
  (require 'use-package))

(use-package exec-path-from-shell
    :init
    (exec-path-from-shell-initialize))

;; -- DAP
(use-package dap-mode
    :init
    (setq-default dap-auto-show-output nil)
    (add-hook 'dap-session-created-hook 'my-dap-session-created-hook)
    (advice-add 'dap--get-path-for-frame :before 'my-get-path-for-frame-advice))

;; -- LSP
(use-package lsp-mode
	:config
    (setq-default lsp-enable-file-watchers nil)
    (setq-default lsp-enable-indentation nil)
	(setq-default lsp-diagnostic-clean-after-change t)
	(apply-lsp-theme)
    (add-hook 'lsp-after-open-hook 'my-lsp-hook))
	

;; -- Magit
(use-package magit
    :config
    (magit-auto-revert-mode -1)
    (add-hook 'git-commit-mode-hook 'my-git-commit-mode-hook))

;; -- Zenburn
(use-package zenburn-theme
    :config
    (apply-zenburn-theme))

;; -- Company
(use-package company
	:config
    (global-company-mode 1)
	(advice-add 'company-capf :around 'my-capf-extra-prefix-check)
	(setq-default company-dabbrev-ignore-case 'keep-prefix)
	(setq-default company-idle-delay nil)
	(setq-default company-backends
		'(company-capf company-files company-ispell company-dabbrev)))
	

;; -- Ivy configuration
(use-package ivy
    :config
	(require 'counsel)
	(require 'ivy-xref)
	(ivy-mode 1)
	(ivy-prescient-mode 1)
	(prescient-persist-mode 1)

	(setq-default ivy-initial-inputs-alist
		(append
			ivy-initial-inputs-alist
			'((counsel-M-x . "")
				 (counsel-describe-variable . "")
				 (counsel-describe-function . ""))))

	(setq-default ivy-prescient-sort-commands
		(append ivy-prescient-sort-commands '(lsp-ivy-workspace-symbol)))

	(setq-default ivy-use-virtual-buffers t)
	(setq-default ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
	(setq-default xref-show-definitions-function #'ivy-xref-show-defs)
	(setq-default xref-show-xrefs-function #'ivy-xref-show-xrefs)

	(defadvice completion-at-point (around my-complete act)
	    (counsel-company))

    (apply-ivy-theme)
	(set-ivy-keybindings))

;; -- Tree-Sitter configuration
(use-package tree-sitter
    :config
    (require 'tree-sitter-langs)
    (global-tree-sitter-mode)
    (add-hook 'tree-sitter-mode-hook 'my-tree-sitter-mode-hook)
    (apply-tree-sitter-theme))

;; -- Ligations
(use-package ligature
    :config
    (ligature-default-ligatures)
    (global-ligature-mode))

(provide '.emacs)
;;; .emacs ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
      '(pet ivy-xref lsp-ivy counsel ivy-prescient magit-lfs magit yasnippet pdf-tools lsp-latex jedi highlight-indent-guides yaml-mode json-mode dockerfile-mode lsp-mode jupyter gnu-elpa-keyring-update ivy exwm smartparens adaptive-wrap zenburn-theme logview csharp-mode company scad-mode dap-mode ligature))
 '(warning-suppress-types '((comp))))
(put 'magit-clean 'disabled nil)
