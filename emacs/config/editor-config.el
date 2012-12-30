(delete-selection-mode t)


(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(global-auto-revert-mode t)


(setq save-place-file (expand-file-name "saveplace" eto-savefile-dir))
(setq-default save-place t)
(require 'saveplace)

(setq savehist-additional-variables
      '(search ring regexp-search-ring)
      savehist-autosave-interval 60
      savehist-file (expand-file-name "savehist" eto-savefile-dir))
(savehist-mode t)

(setq recentf-save-file (expand-file-name "recentf" eto-savefile-dir)
      recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode t)

(setq time-stamp-active t
      time-stamp-line-limit 10
      time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)")
(add-hook 'write-file-hooks 'time-stamp)

;;; much more to do

(provide 'editor-config)
