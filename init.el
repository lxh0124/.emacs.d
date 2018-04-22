(require 'package)

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


(package-initialize)

(setq user-full-name "Tony Li")
(setq user-mail-address "lxh0124@126.com")


(add-to-list 'load-path "~/.emacs.d/elisp")


;; default UI part
(setq-default cursor-type 'hbar)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode 1)
(display-time-mode 1)

(setq default-fill-column 80)
(setq x-select-enable-clipboard t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-screen 1)
(global-set-key (kbd "M-RET") 'other-window)
(global-set-key [f9] 'calendar)
(global-set-key [f10] 'list-bookmarks)
(add-to-list 'default-frame-alist '(fullscreen . maximized))


(setq frame-title-format "emacs@%b")

(global-set-key (kbd "M-g") 'goto-line)

;; Shift + space -> set mark
(global-set-key (kbd "C-SPC") 'nil)
(global-set-key [?\S- ] 'set-mark-command)


(setq show-paren-delay 0)
(show-paren-mode 1)

;; autosave and backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))


(desktop-save-mode 1)

;; set default browser
(setq browse-url-generic-program "google-chrome")
(setq browse-url-browser-function 'browse-url-generic)


;; fast open init file
(defun openInitFile()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f2>") 'openInitFile)

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/work.org"
                             "~/org/school.org" 
                             "~/org/home.org"))


(pop-to-buffer (find-file "~/org/work.org"))


;; third party package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)

(use-package winner
  :defer t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)


(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package window-numbering
  :config
  (window-numbering-mode 1))

(use-package blackboard-theme
  :config
  (load-theme 'blackboard t))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
          helm-input-idle-delay 0.01  ; this actually updates things 
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t)
    (helm-mode))
  :bind (("C-c h" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-b" . helm-buffers-list)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-x c s" . helm-swoop)
         ("C-x c y" . helm-yas-complete)
         ("C-x c Y" . helm-yas-create-snippet-on-region)
         ("C-x c b" . my/helm-do-grep-book-notes)
         ("C-x c SPC" . helm-all-mark-rings)))
(ido-mode -1)

(use-package helm-descbinds
  :defer t
  :bind (("C-h b" . helm-descbinds)
         ("C-h w" . helm-descbinds)))

(use-package helm-swoop
 :bind
 (("C-S-s" . helm-swoop)
  ("M-i" . helm-swoop)
  ("M-s s" . helm-swoop)
  ("M-s M-s" . helm-swoop)
  ("M-I" . helm-swoop-back-to-last-point)
  ("C-c M-i" . helm-multi-swoop)
  ("C-x M-i" . helm-multi-swoop-all)
  )
 :config
 (progn
   (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
   (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop))
)

(use-package smart-mode-line)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package miniedit
  :commands minibuffer-edit
  :init (miniedit-install))


(require 'recentf)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode)

;; js development
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))
(use-package js-comint)

(use-package js2-mode
  :commands js2-mode
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
    (setq-default js2-basic-offset 2)
    (add-to-list 'interpreter-mode-alist (cons "node" 'js2-mode)))
  :config
  (progn
    (bind-key "C-x C-e" 'js-send-last-sexp js2-mode-map)
    (bind-key "C-M-x" 'js-send-last-sexp-and-go js2-mode-map)
    (bind-key "C-c b" 'js-send-buffer js2-mode-map)
    (bind-key "C-c C-b" 'js-send-buffer-and-go js2-mode-map)))

(use-package js2-refactor
  :init
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  :config
  (progn
    (js2r-add-keybindings-with-prefix "C-c C-m")))


(use-package xref-js2
  :config
  (progn
    (define-key js2-mode-map (kbd "M-.") nil)
    (add-hook 'js2-mode-hook (lambda () (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))))

(use-package projectile
  :diminish projectile-mode
  :config
  (progn
    (setq projectile-keymap-prefix (kbd "C-c p"))
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)
    (setq projectile-indexing-method 'alien)
    (add-to-list 'projectile-globally-ignored-files "node-modules"))
  :config
  (projectile-global-mode))
(use-package helm-projectile)

(use-package magit
  :bind
  (("C-x g" . magit-status)))

(use-package swiper-helm
  :bind
  ("C-s" . swiper))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(package-selected-packages
   (quote
    (xref-js2 ace-jump-mode exec-path-from-shell js-comint editorconfig swiper-helm magit solarized-theme helm-projectile helm-swoop color-theme-solarized color-theme miniedit smart-mode-line helm-descbinds auto-compile window-numbering use-package projectile js2-refactor helm company blackboard-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
