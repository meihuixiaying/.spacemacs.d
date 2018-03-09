;;; packages.el --- zilong-ui layer packages file for Spacemacs.
;;
;; Copyright (c) 2014-2016 zilongshanren
;;
;; Author: guanghui <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst zilongshanren-ui-packages
  '(
    (zilong-mode-line :location built-in)
    )
  )

(defun zilongshanren-ui/init-zilong-mode-line ()
  (defun zilongshanren/display-mode-indent-width ()
    (let ((mode-indent-level
           (catch 'break
             (dolist (test spacemacs--indent-variable-alist)
               (let ((mode (car test))
                     (val (cdr test)))
                 (when (or (and (symbolp mode) (derived-mode-p mode))
                           (and (listp mode) (apply 'derived-mode-p mode))
                           (eq 't mode))
                   (when (not (listp val))
                     (setq val (list val)))
                   (dolist (v val)
                     (cond
                      ((integerp v) (throw 'break v))
                      ((and (symbolp v) (boundp v))
                       (throw 'break (symbol-value v))))))))
             (throw 'break (default-value 'evil-shift-width)))))
      (concat "TS:" (int-to-string (or mode-indent-level 0)))))

  (setq my-flycheck-mode-line
        '(:eval
          (pcase flycheck-last-status-change
            ((\` not-checked) nil)
            ((\` no-checker) (propertize " -" 'face 'warning))
            ((\` running) (propertize " ✷" 'face 'success))
            ((\` errored) (propertize " !" 'face 'error))
            ((\` finished)
             (let* ((error-counts (flycheck-count-errors flycheck-current-errors))
                    (no-errors (cdr (assq 'error error-counts)))
                    (no-warnings (cdr (assq 'warning error-counts)))
                    (face (cond (no-errors 'error)
                                (no-warnings 'warning)
                                (t 'success))))
               (propertize (format "[%s/%s]" (or no-errors 0) (or no-warnings 0))
                           'face face)))
            ((\` interrupted) " -")
            ((\` suspicious) '(propertize " ?" 'face 'warning)))))

  (setq-default mode-line-misc-info
                (assq-delete-all 'which-func-mode mode-line-misc-info))

  (setq-default mode-line-format
                (list
                 " %1"
                 '(:eval (propertize
                          (window-number-mode-line)
                          'face
                          'font-lock-type-face))
                 " "
                 '(:eval (zilongshanren/update-persp-name))

                 "%1 "
                 ;; the buffer name; the file name as a tool tip
                 '(:eval (propertize "%b " 'face 'font-lock-keyword-face
                                     'help-echo (buffer-file-name)))


                 " [" ;; insert vs overwrite mode, input-method in a tooltip
                 '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
                                     'face 'font-lock-preprocessor-face
                                     'help-echo (concat "Buffer is in "
                                                        (if overwrite-mode
                                                            "overwrite"
                                                          "insert") " mode")))

                 ;; was this buffer modified since the last save?
                 '(:eval (when (buffer-modified-p)
                           (concat "," (propertize "Mod"
                                                   'face 'font-lock-warning-face
                                                   'help-echo "Buffer has been modified"))))

                 ;; is this buffer read-only?
                 '(:eval (when buffer-read-only
                           (concat "," (propertize "RO"
                                                   'face 'font-lock-type-face
                                                   'help-echo "Buffer is read-only"))))
                 "] "

                 ;; anzu
                 anzu--mode-line-format

                 ;; relative position, size of file
                 "["
                 (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
                 "/"
                 (propertize "%I" 'face 'font-lock-constant-face) ;; size
                 "] "

                 ;; the current major mode for the buffer.
                 '(:eval (propertize "%m" 'face 'font-lock-string-face
                                     'help-echo buffer-file-coding-system))

                 "%1 "
                 my-flycheck-mode-line
                 "%1 "
                 ;; evil state
                 '(:eval evil-mode-line-tag)

                 ;; minor modes
                 '(:eval (when (> (window-width) 90)
                           minor-mode-alist))
                 " "
                 ;; git info
                 '(:eval (when (> (window-width) 120)
                           `(vc-mode vc-mode)))

                 " "

                 ;; global-mode-string goes in mode-line-misc-info
                 '(:eval (when (> (window-width) 120)
                           mode-line-misc-info))

                 (mode-line-fill 'mode-line 20)

                 '(:eval (zilongshanren/display-mode-indent-width))
                 ;; line and column
                 " (" ;; '%02' to set to 2 chars at least; prevents flickering
                 (propertize "%02l" 'face 'font-lock-type-face) ","
                 (propertize "%02c" 'face 'font-lock-type-face)
                 ") "

                 '(:eval (when (> (window-width) 80)
                           (buffer-encoding-abbrev)))
                 mode-line-end-spaces
                 ;; add the time, with the date and the emacs uptime in the tooltip
                 ;; '(:eval (propertize (format-time-string "%H:%M")
                 ;;                     'help-echo
                 ;;                     (concat (format-time-string "%c; ")
                 ;;                             (emacs-uptime "Uptime:%hh"))))
                 )))
