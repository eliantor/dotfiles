(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-user-dir (expand-file-name "elpa" eto-root-dir))
(package-initialize)

(setq url-http-attempt-keepalives nil)


(defun eto-install-all ()
  (unless (-all? #'package-installed-p eto-package-list)
    (message "%s" "Refreshing packages database...")
    (package-refresh-contents)
    (message "%s" " done")
    (-each
     (-remove #'package-installed-p eto-package-list)
     #'package-install)))

(eto-install-all)

(defun ensure-deps (packages)
  (-each (-remove #'package-installed-p packages) #'package-install))

(provide 'package-config)
