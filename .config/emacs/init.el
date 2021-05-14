;;twelf configurations
(setq twelf-root "/opt/twelf/")
(load (concat twelf-root "emacs/twelf-init.el"))

;;general configurations
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard nil)
(global-set-key (kbd "<mouse-2>") 'clipboard-yank)

;;enable cua mode
(cua-mode t)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; enable MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(gruvbox-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'gruvbox t)
