(ensure-deps '(auto-complete))
(require 'auto-complete)
(require 'auto-complete-config)

(ac-config-default)
(setq ac-auto-start nil)
(setq ac-dwim t)



;(define-key ac-complete-mode-map "\C-n" 'ac-next)
;(define-key ac-complete-mode-map "\C-p" 'ac-previous)
;(define-key ac-complete-mode-map "\t" 'ac-complete)



(when (boundp 'ac-modes)
  (setq ac-modes
	(append ac-modes (list 'nrepl-mode 'nrepl-interaction-mode))))

(provide 'prog-config)
