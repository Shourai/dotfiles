(let ((gc-cons-threshold most-positive-fixnum))
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

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
)
