;;; packages.el --- zilongshanren Layer packages File for Spacemacs
;;
;; Copyright (c) 2014-2016 zilongshanren
;;
;; Author: zilongshanren <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.

(setq zilongshanren-programming-packages
      '(
        flycheck
        yasnippet
        (python :location built-in)
        company
        dumb-jump
        ))


(defun zilongshanren-programming/init-editorconfig ()
  (use-package editorconfig
    :init
    (progn
      (defun conditional-enable-editorconfig ()
        (if (and (zilongshanren/vcs-project-root)
                 (locate-dominating-file default-directory ".editorconfig"))
            (editorconfig-apply)))
      (add-hook 'prog-mode-hook 'conditional-enable-editorconfig))))

(defun zilongshanren-programming/post-init-dumb-jump ()
  (setq dumb-jump-selector 'ivy)
  (defun my-dumb-jump ()
    (interactive)
    (evil-set-jump)
    (dumb-jump-go))
  (global-set-key (kbd "C-s-g") 'my-dumb-jump))

(defun zilongshanren-programming/post-init-clojure-mode ()
  )

(defun zilongshanren-programming/post-init-python ()
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  ;; if you use pyton3, then you could comment the following line
  (setq python-shell-interpreter "python"))

(defun zilongshanren-programming/init-ctags-update ()
  (use-package ctags-update
    :init
    :defer t
    :config
    (spacemacs|hide-lighter ctags-auto-update-mode)))

(defun zilongshanren-programming/post-init-yasnippet ()
  (progn
    (set-face-background 'secondary-selection "gray")
    (setq-default yas-prompt-functions '(yas-ido-prompt yas-dropdown-prompt))
    (mapc #'(lambda (hook) (remove-hook hook 'spacemacs/load-yasnippet)) '(prog-mode-hook
                                                                      org-mode-hook))

    (spacemacs/add-to-hooks 'zilongshanren/load-yasnippet '(prog-mode-hook
                                                            org-mode-hook))
    ))

(defun zilongshanren-programming/init-flycheck-package ()
  (use-package flycheck-package))

(defun zilongshanren-programming/init-google-c-style ()
  (use-package google-c-style
    :init (add-hook 'c-mode-common-hook 'google-set-c-style)))

(defun zilongshanren-programming/post-init-flycheck ()
  (with-eval-after-load 'flycheck
    (progn
      (setq flycheck-display-errors-delay 0.9)
      (setq flycheck-idle-change-delay 2.0)
      )))

(defun zilongshanren-programming/post-init-tagedit ()
  (add-hook 'web-mode-hook (lambda () (tagedit-mode 1))))

;; For each extension, define a function zilongshanren/init-<extension-name>
;;
(defun zilongshanren-programming/init-doxymacs ()
  "Initialize doxymacs"
  (use-package doxymacs
    :init
    (add-hook 'c-mode-common-hook 'doxymacs-mode)
    :config
    (progn
      (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)
      (spacemacs|hide-lighter doxymacs-mode))))

(defun zilongshanren-programming/init-flycheck-clojure ()
  (use-package flycheck-clojure
    :defer t
    :init
    (eval-after-load 'flycheck '(flycheck-clojure-setup))))

(defun zilongshanren-programming/post-init-ycmd ()
  (progn
    (setq ycmd-tag-files 'auto)
    (setq ycmd-request-message-level -1)
    (set-variable 'ycmd-server-command `("python" ,(expand-file-name "~/Github/ycmd/ycmd/__main__.py")))
    (setq company-backends-c-mode-common '((company-c-headers
                                            company-dabbrev-code
                                            company-keywords
                                            company-gtags :with company-yasnippet)
                                           company-files company-dabbrev ))

    (zilongshanren|toggle-company-backends company-ycmd)
    (eval-after-load 'ycmd
      '(spacemacs|hide-lighter ycmd-mode))

    (spacemacs/set-leader-keys-for-major-mode 'c-mode
      "tb" 'zilong/company-toggle-company-ycmd)
    (spacemacs/set-leader-keys-for-major-mode 'c++-mode
      "tb" 'zilong/company-toggle-company-ycmd)))

(defun zilongshanren-programming/init-gulpjs ()
  (use-package gulpjs
    :init
    (progn
      (defun zilong/build-engine ()
        (interactive)
        (gulpjs-start-task-with-file-name "~/Github/fireball/app.js"))

      (spacemacs/set-leader-keys "ags" 'gulpjs-start-task)
      (spacemacs/set-leader-keys "agS" 'zilong/build-engine)
      (spacemacs/set-leader-keys "agr" 'gulpjs-restart-task))))

(defun zilongshanren-programming/post-init-company ()
  (progn
    (setq company-minimum-prefix-length 1
          company-idle-delay 0.08)

    (when (configuration-layer/package-usedp 'company)
      (spacemacs|add-company-backends :modes shell-script-mode makefile-bsdmake-mode sh-mode lua-mode nxml-mode conf-unix-mode json-mode graphviz-dot-mode))
    ))
