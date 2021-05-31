;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       company
       ivy

       :ui
       doom
       ;; doom-dashboard
       doom-quit
       (emoji +unicode)
       fill-column
       hl-todo
       (modeline +light)
       ;;nav-flash         ; blink cursor line after big motions
       ophints
       (popup +defaults)
       ;;unicode           ; extended unicode support for various languages
       vc-gutter
       vi-tilde-fringe
       ;;window-select     ; visually switch windows
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       format
       ;;multiple-cursors  ; editing in many places at once
       snippets
       word-wrap
       syntax
       (spell +flyspell)
       ;;grammar           ; tasing grammar mistake every you make

       :tools
       ansible
       debugger
       direnv
       docker
       editorconfig
       (eval +overlay)
       gist
       lookup
       lsp
       (magit +forge)
       make
       pdf
       ;;rgb               ; creating color strings
       taskrunner
       terraform
       tmux
       ;;upload            ; map local to remote projects via ssh/ftp

       :os
       (:if IS-MAC macos)

       :lang
       data
       (dart +flutter)
       elixir
       emacs-lisp
       faust
       (go +lsp)
       json
       (java +meghanada)
       javascript
       julia
       kotlin
       latex
       lua
       markdown
       (org +roam)
       (php +lsp)
       (python +lsp +pyenv +poetry)
       rest
       rst
       (ruby +rails +rbenv +lsp)
       (rust +lsp)
       (sh +lsp)
       swift
       (web +lsp)
       yaml

       :email
       ;; nothing to see here...

       :app
       calendar

       :config
       (default +bindings +smartparens))
