;;twelf configurations
(setq twelf-root "/opt/twelf/")
(load (concat twelf-root "emacs/twelf-init.el"))

;;general configurations
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard nil)
(global-set-key (kbd "<mouse-2>") 'clipboard-yank)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
