;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq gc-cons-threshold (* 50 1000 1000))

(require 'package)
(setq package-enable-at-startup nil)
(setq package-quickstart t)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

;; Always make sure emacs.el is tangled from the latest .org file.
(setq org-file (expand-file-name "emacs.org" user-emacs-directory))
(setq el-file (expand-file-name "emacs.el" user-emacs-directory))

(if (file-newer-than-file-p org-file el-file)
   (org-babel-load-file org-file)
  (load-file el-file)
  )

;; Load customization settings file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
;; Make gc pauses faster by decreasing the threshold.
;(setq gc-cons-threshold (* 2 1000 1000))
