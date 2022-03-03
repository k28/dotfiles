
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; package settings
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; install packages
(defvar my/favorite-packages
  '(
    ;;; for auto-complete
    auto-complete
    ;;; plantuml
    plantuml-mode
    ;;; maekdown
    markdown-mode
		  ))
;; my/favorite-packagesからインストールしていないパッケージをインストール
(defvar my/package-is-update nil)
(dolist (package my/favorite-packages)
  (unless (package-installed-p package)
    (unless my/package-is-update
      ;; package がインストールされていなかったらpackageリストを更新する
      (progn
       (setq my/package-is-update t)
       (package-refresh-contents)
      :)
    )
    (package-install package)))

;; color theme
(add-to-list 'custom-theme-load-path
  (file-name-as-directory "~/.emacs.d/themes/"))

(load-theme 'desert t t)
(enable-theme 'desert)

;; backup file setting
(setq maek-backup-files nil)
(setq auto-save-default nil)

;; Gosh setting
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

;; yank to clipboard
(setq x-select-enable-clipboard t)

;; Scroll setting
(setq scroll-conservarively 1)
(setq scroll-mergine 5)
(setq scroll-preserve-screen-position t)

;; 右から左に読む言語に対応させない事で描画を高速化
(setq-default bidi-display-reordering nil)

;; 同じ内容を履歴に記録しない
(setq history-delete-duplicates t)

;; C-u C-SPC C-SPC...で過去のマークを遡る
(setq set-mark-command-repeat-pop t)

;; 複数のディレクトリで同じファイル名のファイルを開いた時のバッファ名を調整する
(require 'uniquify)
;; filename<dir>形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "[^*]+")

;; ファイルを開いた位置を保持する
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))

;; 釣合う括弧をハイライトする
(show-paren-mode 1)

;; 現在行に色をつける
;; (global-hl-line-mode 1)

;; ミニバッファ履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;; モードラインに時刻を表示
(display-time)

;; 行番号, 桁番号を表示
(line-number-mode 1)
(column-number-mode 1)

;; GCを減らして軽くする
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;; ログの記録行数を増やす
(setq message-log-max 10000)

;; 履歴をたくさん保存する
(setq history-length 1000)

;; Auto Complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(ac-set-trigger-key "TAB")
(global-auto-complete-mode t)

;; plantuml-mode
(add-to-list 'auto-mode-alist '("\.pu$" . plantuml-mode))

;; maekdown-mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md$" . gfm-mode))

;; EOF
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(plantuml-mode auto-complete)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
