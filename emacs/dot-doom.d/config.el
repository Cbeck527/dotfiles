;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Chris Becker"
      user-mail-address "chris@becker.am")

(setq doom-font (font-spec :family "Mplus Code" :size 16)
      doom-variable-pitch-font (font-spec :family "Helvetica" :size 16))

(setq doom-theme 'solarized-dark)

(setq display-line-numbers-type t)

(setq doom-leader-key ","
      doom-localleader-key "-")

(setq auth-sources '("~/.authinfo"))

;; Solarized tweaks: avoid all font-size changes
;; (setq-default display-line-numbers-width-start t)
(setq solarized-use-variable-pitch nil
      solarized-scale-org-headlines nil)
(setq solarized-use-less-bold t)

(add-hook! 'after-init-hook 'load-framegeometry)
(add-hook! 'kill-emacs-hook 'save-framegeometry)

(setq
  org-src-tab-acts-natively t
  org-confirm-babel-evaluate nil
  org-catch-invisible-edits "error"
  org-archive-location "_archive_org::"
  org-enforce-todo-dependencies t
  org-enforce-todo-checkbox-dependencies t
  org-log-into-drawer t
  org-hide-emphasis-markers t
  org-fontify-done-headline t
  org-fontify-whole-heading-line t
  org-fontify-quote-and-verse-blocks t
  org-directory "/Users/chris/Library/Mobile Documents/com~apple~CloudDocs/org/"
  org-roam-directory org-directory
  org-default-notes-file "~/inbox.org"
  org-startup-folded "content")

(after! org-agenda
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 'week
      org-agenda-start-on-weekday nil
      org-agenda-window-setup "only-window")
  (setq org-super-agenda-groups
      '((:name "Next Items"
               :time-grid t
               :tag ("NEXT" "outbox"))
        (:name "Important"
               :priority "A")
        (:name "Quick Picks"
               :effort< "0:30")
        (:priority<= "B"
                     :scheduled future
                     :order 1)))
)


; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun cb/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'cb/verify-refile-target)

;; open org-agenda with a better keymap
(map! :leader
      "o a" 'org-agenda-list)

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


(defun org-projectile-get-project-todo-file (project-path)
  (concat "~/org/" (file-name-nondirectory (directory-file-name project-path)) ".org"))

;; open projectile-dired with , p P
;; open magit-status on project with , p G
(map! :leader
      "p P" 'projectile-switch-project-dired
      "p G"'projectile-switch-project-magit)

;;
;; custom functions!
;;
(defun projectile-switch-project-dired ()
  "open projectile-dired with , p P"
  (interactive)
  (progn
    (setq projectile-switch-project-action 'projectile-dired)
    (projectile-switch-project)
    (setq projectile-switch-project-action 'projectile-find-file)))

(defun projectile-switch-project-magit ()
  "open projectile-dired with , p G"
  (interactive)
  (progn
    (setq projectile-switch-project-action 'magit-status)
    (projectile-switch-project)
    (setq projectile-switch-project-action 'projectile-find-file)))

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

(setq +org-capture-frame-parameters
  `((name . "Org Capture")
    (left . (+ 550))
    (top . (+ 400))
    (width . 110)
    (height . 12)
    (transient . t)
    ,(when (and IS-LINUX (not (getenv "DISPLAY")))
       `(display . ":0"))
    ,(if IS-MAC '(menu-bar-lines . 1))))

(defun my-org-capture-cleanup ()
  "Clean up the frame created while capturing via org-protocol."
  (-when-let ((&alist 'name name) (frame-parameters))
    (when (equal name "global-org-capture")
      (delete-frame))))

(add-hook! 'org-capture-after-finalize-hook 'my-org-capture-cleanup)
