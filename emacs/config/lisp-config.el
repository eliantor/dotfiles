(require 'prog-config)
(ensure-deps '(rainbow-delimiters paredit))

(defun lisp-mode-common-hooks ()
  (show-paren-mode +1)
  (paredit-mode +1)
  (rainbow-delimiters-mode +1)
  (local-set-key (kbd "RET") 'newline-and-indent))

(setq lisp-code-hooks 'lisp-mode-common-hooks)

(provide 'lisp-config)
