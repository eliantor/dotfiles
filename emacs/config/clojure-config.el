(require 'lisp-config)
(ensure-deps '(clojure-mode nrepl ac-nrepl nrepl-ritz))
(require 'auto-complete)
(require 'ac-nrepl)

(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(defun eto-auto-complete-setup ()
  (setq completion-at-point-functions '(auto-complete)))

(defun eto-nrepl-setup ()
  (require 'nrepl-ritz)
  (nrepl-turn-on-eldoc-mode)
  (auto-complete-mode)
  (ac-nrepl-setup)
  (eto-auto-complete-setup))

(define-key nrepl-interaction-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc)




(add-hook 'auto-complete-mode-hook 'eto-auto-complete-setup)

(add-hook 'nrepl-mode-hook 'eto-nrepl-setup)

(add-hook 'nrepl-interaction-mode-hook 'eto-nrepl-setup)

(add-hook 'clojure-mode-hook 
	  (lambda ()
	    (run-hooks 'lisp-code-hooks)))
(provide 'clojure-config)
