;;; Keybindings --- custom keybindings
;;; Commentary:
;;; Code:

(require 'joes-utils)

(defun simulate-command-key()
	(global-set-key (kbd "s-v") 'yank)
	(global-set-key (kbd "s-x") 'kill-region)
	(global-set-key (kbd "s-c") 'kill-ring-save)
	(global-set-key (kbd "s-u") 'revert-buffer))

(defun set-exwm-keybindings()
	(exwm-input-set-key (kbd "s-k") 'exwm-input-release-keyboard))

(defun set-common-exwm-simulation-keys()
	(exwm-input-set-simulation-key (kbd "s-c") (kbd "C-<insert>"))
	(exwm-input-set-simulation-key (kbd "s-v") (kbd "S-<insert>"))
	(exwm-input-set-simulation-key (kbd "s-x") (kbd "C-x"))
	(exwm-input-set-simulation-key (kbd "C-s") (kbd "C-f"))
	(exwm-input-set-simulation-key (kbd "C-g") (kbd "<escape>"))
	(exwm-input-set-simulation-key (kbd "M-p") (kbd "<up>"))
	(exwm-input-set-simulation-key (kbd "M-n") (kbd "<down>"))
	(exwm-input-set-simulation-key (kbd "M-b") (kbd "C-<left>"))
	(exwm-input-set-simulation-key (kbd "M-f") (kbd "C-<right>")))

(defun set-common-keybindings()
	"Set keys used everywhere."
	;; Unset some keybindings that I hate!
	(global-unset-key (kbd "C-v"))
	(global-unset-key (kbd "M-v"))
	(global-unset-key (kbd "C-x C-z"))

	(global-set-key (kbd "C-z") 'undo)
	(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 1)))
	(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 1)))
	(global-set-key (kbd "C-|") 'toggle-window-split)
	(global-set-key (kbd "C-<tab>") (lambda () (interactive) (insert-tab)))
	(global-set-key [remap shell-command] 'async-shell-command)
	(global-set-key [remap indent-for-tab-command] 'indent-or-complete)
	(global-set-key [remap c-indent-line-or-region] 'indent-or-complete)
	(global-set-key (kbd "<backtab>") 'indent-according-to-mode)
	(global-set-key (kbd "C-c o") 'consult-imenu)
	(define-key minibuffer-local-map (kbd "<tab>") 'complete-symbol)

	(global-set-key (kbd "C-c C-r") 'xref-find-references)

	;; Remove remapping of kill-line to kill-visual-line
	(define-key visual-line-mode-map [remap kill-line] nil)

	(global-set-key [remap isearch-forward] 'isearch-forward-regexp)
	(global-set-key [remap isearch-backward] 'isearch-backward-regexp))

(defun set-git-commit-keybindings()
	(local-set-key [remap indent-for-tab-command] 'completion-at-point))

(defun set-python-keybindings()
	(local-set-key (kbd "C-.") (lambda () (interactive)
								   (python-indent-line)))
	(local-set-key (kbd "C-,") 'python-indent-shift-left))

(defun set-ivy-keybindings()
	(global-set-key (kbd "M-x") 'counsel-M-x)
	(global-set-key [remap describe-function] 'counsel-describe-function)
	(global-set-key [remap describe-variable] 'counsel-describe-variable)
	(global-set-key (kbd "C-M-y") 'counsel-yank-pop)
	(global-set-key (kbd "C-c C-f") 'counsel-git)
	(global-set-key [remap isearch-forward-regexp] 'counsel-grep-or-swiper)
	(global-set-key [remap ivy-done] 'ivy-alt-done)
	(global-set-key [remap ivy-partial-or-done] 'ivy-partial)
	(global-set-key [remap imenu] 'counsel-imenu)

	;; minibuffer keys
	(ivy-define-key ivy-minibuffer-map (kbd "M-p") 'ivy-previous-line)
	(ivy-define-key ivy-minibuffer-map (kbd "M-n") 'ivy-next-line)
	(ivy-define-key ivy-minibuffer-map (kbd "C-p") 'ivy-previous-history-element)
	(ivy-define-key ivy-minibuffer-map (kbd "C-n") 'ivy-next-history-element))

(defun set-lsp-keybinding ()
	(require 'ivy)
	(local-set-key (kbd "C-c C-t") 'lsp-ivy-workspace-symbol)
	(local-set-key (kbd "C-c C-r") 'lsp-find-references)
	(local-set-key (kbd "C-c C-i") 'lsp-find-implementation)
	(local-set-key (kbd "C-c C-d") 'lsp-find-declaration)
	(local-set-key (kbd "C-c C-a") 'lsp-execute-code-action))

(provide 'joes-keybindings)
;;; joes-keybindings.el ends here
