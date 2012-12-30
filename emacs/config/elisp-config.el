(require 'lisp-config)

(defun eto-clear-elc-on-buffer-save ()
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
	    (lambda ()
	      (if (file-exists-p (concat buffer-file-name "c"))
		  (delete-file (concat buffer-file-name "c"))))))

(add-hook 'emacs-lisp-mode-hook 
	  (lambda ()
	    (run-hooks 'lisp-code-hooks)
	    (turn-on-eldoc-mode)
	    (eto-clear-elc-on-buffer-save)))
(provide 'elisp-config)
