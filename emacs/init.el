(setq stacktrace-on-error t)

(defvar eto-root-dir (file-name-directory load-file-name))

(defvar eto-vendor-dir (expand-file-name "vendor" eto-root-dir))

(defvar eto-snippets-dir (expand-file-name "snippets" eto-root-dir))

(defvar eto-base-dir (expand-file-name "core" eto-root-dir))

(defvar eto-config-dir (expand-file-name "config" eto-root-dir ))

(defvar eto-savefile-dir (expand-file-name "savefile" eto-root-dir))

(defvar eto-package-list 
  '(exec-path-from-shell))

(unless (file-exists-p eto-savefile-dir)
  (make-directory eto-savefile-dir))


(add-to-list 'load-path eto-base-dir)
(add-to-list 'load-path eto-config-dir)
(add-to-list 'load-path eto-vendor-dir)

(require 'dash)
(require 'package-config)
(require 'editor-config)
(require 'ui-config)
(require 'magit-config)
(when (eq system-type "darwin")
  (require 'osx-config))
(require 'elisp-config)
(require 'clojure-config)

(setq custom-file (expand-file-name "custom.el" eto-config-dir))
