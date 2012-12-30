(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(require 'server)
(defun eto-config-frame (frame)
  "New frame behaviour"
  (if (eq system-type 'darwin)
      (if (server-running-p)
	  (with-selected-frame frame
	    (if (display-graphic-p)
		(modify-frame-parameters frame '((menu-bar-lines . 1)))
	      (modyfy-frame-parameters frame '((menu-bar-lines . 0)))))
	(if (display-graphic-p)
	    (modify-frame-parameters frame '((menu-bar-lines . 1)))
	  (modify-frame-parameters frame '((menu-bar-lines . 0)))))
    (menu-bar-mode -1)))

(eto-config-frame (selected-frame))

(add-hook 'after-make-frame-functions 'eto-config-frame)

(blink-cursor-mode -1)

(setq inhibit-startup-screen t)

(setq scroll-margin 0
      scroll-conservatively 100000
      scrool-preserve-screen-position 1)

(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)


(when (fboundp 'fringe-mode)
    (fringe-mode 4))

(fset 'yes-or-no-p 'y-or-n-p)

(if (display-graphic-p)
    (load-theme 'solarized-dark t)
  (load-theme 'twilight t))

(provide 'ui-config)
