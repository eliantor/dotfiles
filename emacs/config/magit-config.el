(ensure-deps '(magit))

(require 'magit)

(add-hook 'magit-log-edit-mode-hook
	  (lambda ()
	    (set-fill-column 72)
	    (auto-fill-mode 1)))

(global-set-key (kbd "C-x g") 'magit-status)
(provide 'magit-config)
