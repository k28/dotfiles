
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

; color theme
(add-to-list 'custom-theme-load-path
  (file-name-as-directory "~/.emacs.d/themes/"))

(load-theme 'desert t t)
(enable-theme 'desert)

; Gosh setting
(modify-coding-system-alist 'process "gosh" '(utf-8 . utf-8))

(setq scheme-program-name "gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process" t)

(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
    (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(define-key global-map
  "\C-cs" 'scheme-other-window)

; yank to clipboard
(setq x-select-enable-clipboard t)

; Scroll setting
(setq scroll-conservarively 1)
(setq scroll-mergine 5)
(setq scroll-preserve-screen-position t)
