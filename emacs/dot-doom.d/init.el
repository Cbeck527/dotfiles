;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       company
       (vertico +icons)

       :ui
       doom
       doom-quit
       (emoji +unicode)
       hl-todo
       (modeline +light)
       ophints
       (popup +defaults)
       vc-gutter
       vi-tilde-fringe
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       format
       snippets
       word-wrap

       :emacs
       dired
       ;;electric
       ;;ibuffer
       (undo +tree)
       vc

       :checkers
       syntax
       (spell +flyspell)
       grammar

       :tools
       ansible
       debugger
       docker
       (eval +overlay)
       gist
       lookup
       lsp
       (magit +forge)
       make
       pdf
       taskrunner
       terraform

       :os
       (:if IS-MAC macos)

       :lang
       (cc +lsp)
       (clojure +lsp)
       data
       elixir
       emacs-lisp
       (go +lsp)
       json
       javascript
       julia
       latex
       lua
       markdown
       (org +dragndrop +hugo +pandoc +present +pretty +roam2)
       (php +lsp)
       (python +lsp +pyenv)
       rest
       rst
       (ruby +rails +rbenv +lsp)
       (rust +lsp)
       (sh +lsp)
       swift
       (web +lsp)
       yaml

       :config
       (default +bindings +smartparens))
