;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;; Global Doom things
;;
(setq user-full-name "Chris Becker"
      user-mail-address "chris@becker.am")
(setq doom-leader-key ","
      doom-localleader-key "-")
(setq auth-sources '("~/.authinfo"))

;; Hide commands in M-x which do not work in the current mode. Vertico commands
;; are hidden in normal buffers.
(use-package! emacs
  :init
  (setq read-extended-command-predicate
        #'command-completion-default-include-p))

;;
;; Theme stuff
;;
(setq doom-font (font-spec :family "Mplus Code" :size 16)
      doom-variable-pitch-font (font-spec :family "Helvetica" :size 16))
;; Solarized tweaks: avoid all font-size changes
(setq-default display-line-numbers-width-start t)
(setq solarized-use-variable-pitch nil
      solarized-scale-org-headlines nil)
;; (setq solarized-use-less-bold t)
(setq doom-theme 'solarized-dark)
(setq display-line-numbers-type t)

;;
;; ALL THE ORG THINGS
;;
(defun cb/exclude-done-in-refile ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(after! org
  (setq org-src-tab-acts-natively t
        org-confirm-babel-evaluate nil
        org-catch-invisible-edits "error"
        org-archive-location "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/archives/%s_archive::"
        org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t
        org-todo-keywords '((sequence "TODO" "DOING" "|" "DONE" "DELEGATED" "ABANDONED"))
        org-log-into-drawer t
        ; Exclude DONE state tasks from refile targets
        org-refile-target-verify-function 'cb/exclude-done-in-refile
        org-hide-emphasis-markers t
        org-fontify-done-headline t
        org-fontify-whole-heading-line t
        org-fontify-quote-and-verse-blocks t
        org-directory "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/"
        org-default-notes-file "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/pages/Inbox.org"
        org-link-elisp-confirm-function nil
        ;; org refiling tweaks - targets include this file and any file contributing to
        ;; the agenda - up to 9 levels deep
        org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9)))
        ;; Use full outline paths for refile targets - we file directly with IDO
        org-refile-use-outline-path 'file
        org-startup-folded "content"))

(after! org-agenda
  (setq org-agenda-files (list "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/journals/"
                               "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/pages/")
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-start-day nil ;; i.e. today
        org-agenda-span 'week
        org-agenda-start-on-weekday nil
        org-agenda-window-setup "only-window"))

;; keymaps
(map! :after evil-org-agenda
      :map evil-org-agenda-mode-map
      ;; view modes
      :m "ds" 'org-agenda-schedule
      :m "dd" 'org-agenda-deadline
      :m "vd" 'org-agenda-day-view
      :m "vw" 'org-agenda-week-view
      :m "vm" 'org-agenda-month-view
      ;; navigation
      :m "f" 'org-agenda-later
      :m "b" 'org-agenda-earlier)

;; ;;
;; ;; org-projectile
;; ;;
(after! projectile
  ;; TODO investigate this
  ;; https://docs.projectile.mx/projectile/configuration.html#projectile-dired
  ;; (setq projectile-switch-project-action #'projectile-find-file
  ;;       projectile-find-dir-includes-top-level t)
  (org-projectile-per-project))
(after! org-projectile
  (push (org-projectile-project-todo-entry) org-capture-templates)
  (setq org-projectile-projects-directory "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/pages/"
        org-projectile-allow-tramp-projects nil
        org-link-elisp-confirm-function nil
        org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
  (add-to-list 'org-capture-templates
               (org-projectile-project-todo-entry
               :capture-character "l"
               :capture-heading "Project TODO"))
  (defun org-projectile-get-project-todo-file (project-path)
    (concat "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/pages/" (projectile-project-name) ".org")))

(defun cb/org-todos-for-current-project ()
  "Open org-todo-list for the current project"
  (interactive)
  (let* ((org-agenda-tag-filter-preset (list (concat "+" projectile-project-name))))
    (org-todo-list)))
(map! :leader :desc "Open project TODOs" "p t" #'cb/org-todos-for-current-project)

(defun cb/open-org-file-for-project-other-window ()
  "Open the project's org file in another window"
  (interactive)
  (find-file-other-window (concat "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/pages/" (projectile-project-name) ".org")))
(map! :leader :desc "Project's org file other window" "p o" #'cb/open-org-file-for-project-other-window)

(defun cb/open-org-file-for-project ()
  "Open the project's org file"
  (interactive)
  (find-file (concat "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB/pages/" (projectile-project-name) ".org")))
(map! :leader :desc "Open project's org file" "p O" #'cb/open-org-file-for-project)
;; ;;
;; ;; org-roam v2
;; ;;
;; (after! org-roam
;;   (setq org-roam-directory "/Users/chris/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/CMB"
;;         org-roam-dailies-directory "journals/"
;;         org-roam-capture-templates
;;          '(("d" "default" plain
;;             "%?" :target
;;             (file+head "pages/${slug}.org" "#+title: ${title}\n")
;;             :unnarrowed t))))
;;
;; org keymaps
;;
;; ;; open org-agenda with a better keymap
;; (map! :leader
;;       "o a" 'org-agenda-list)

;;
;; Org capture
;;
;; (setq +org-capture-frame-parameters
;;   `((name . "Org Capture")
;;     (left . (+ 550))
;;     (top . (+ 400))
;;     (width . 110)
;;     (height . 12)
;;     (transient . t)
;;     ,(when (and IS-LINUX (not (getenv "DISPLAY")))
;;        `(display . ":0"))
;;     ,(if IS-MAC '(menu-bar-lines . 1))))

;; (defun my-org-capture-cleanup ()
;;   "Clean up the frame created while capturing via org-protocol."
;;   (-when-let ((&alist 'name name) (frame-parameters))
;;     (when (equal name "global-org-capture")
;;       (delete-frame))))

;; (add-hook! 'org-capture-after-finalize-hook 'my-org-capture-cleanup)

;;
;; Don't spell check everywhere, just where I want.
;;
(remove-hook 'text-mode-hook #'spell-fu-mode)
(add-hook 'markdown-mode-hook #'spell-fu-mode)

;;
;; Save my window size pls
;;
(add-hook! 'after-init-hook 'load-framegeometry)
(add-hook! 'kill-emacs-hook 'save-framegeometry)

(defun save-framegeometry ()
  "Get the current frame's geometry and saves to ~/.emacs.d/.local/framegeometry."
  (let (
        (framegeometry-left (frame-parameter (selected-frame) 'left))
        (framegeometry-top (frame-parameter (selected-frame) 'top))
        (framegeometry-width (frame-parameter (selected-frame) 'width))
        (framegeometry-height (frame-parameter (selected-frame) 'height))
        (framegeometry-file (expand-file-name "~/.emacs.d/.local/framegeometry"))
        )

    (when (not (number-or-marker-p framegeometry-left))
      (setq framegeometry-left 0))
    (when (not (number-or-marker-p framegeometry-top))
      (setq framegeometry-top 0))
    (when (not (number-or-marker-p framegeometry-width))
      (setq framegeometry-width 0))
    (when (not (number-or-marker-p framegeometry-height))
      (setq framegeometry-height 0))

    (with-temp-buffer
      (insert
       ";;; This is the previous emacs frame's geometry.\n"
       ";;; Last generated " (current-time-string) ".\n"
       "(setq initial-frame-alist\n"
       "      '(\n"
       (format "        (top . %d)\n" (max framegeometry-top 0))
       (format "        (left . %d)\n" (max framegeometry-left 0))
       (format "        (width . %d)\n" (max framegeometry-width 0))
       (format "        (height . %d)))\n" (max framegeometry-height 0)))
      (when (file-writable-p framegeometry-file)
        (write-file framegeometry-file))))
)

(defun load-framegeometry ()
  "Load ~/.emacs.d/.local/framegeometry which should load the previous frame's
geometry."
  (let ((framegeometry-file (expand-file-name "~/.emacs.d/.local/framegeometry")))
    (when (file-readable-p framegeometry-file)
      (load-file framegeometry-file)))
  )
