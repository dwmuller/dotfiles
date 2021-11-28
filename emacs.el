
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Package mgmt
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(require 'use-package-ensure)
(setq use-package-always-ensure t) ; Always auto-install if needed.

(use-package paradox)

;; Software development in general
(use-package company)
(use-package flycheck :init (global-flycheck-mode))

;; Markdown
(use-package markdown-mode)

;; C# development
(use-package omnisharp
  :after company
  :config
  (add-hook 'csharp-mode-hook 'omnisharp-mode)
  (add-to-list 'company-backends 'company-omnisharp))


;; Experiments based on https://karthinks.com/software/batteries-included-with-emacs/

;; Pulse the current line when switching frames.
(load "pulse.el")
(defun pulse-line (&rest _)
      "Pulse the current line."
      (pulse-momentary-highlight-one-line (point)))

(dolist (command '(scroll-up-command scroll-down-command
                   recenter-top-bottom other-window))
  (advice-add command :after #'pulse-line))

;; Use pager-like binding in read-only mode.
(setq view-read-only t)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (markdown-mode paradox company omnisharp use-package)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
