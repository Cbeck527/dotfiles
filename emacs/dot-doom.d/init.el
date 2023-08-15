;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       (company +childframe)
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
       (syntax +childframe)
       (spell +aspell)
       grammar

       :tools
       ansible
       (debugger +lsp)
       direnv
       (docker +lsp)
       editorconfig
       (eval +overlay)
       gist
       lookup
       lsp
       (magit +forge)
       make
       pdf
       taskrunner
       terraform
       tree-sitter
       tmux

       :os
       (:if IS-MAC macos)

       :lang
       (cc +lsp +tree-sitter)
       (clojure +lsp)
       data
       (elixir +lsp +tree-sitter)
       (erlang +lsp)
       emacs-lisp
       (go +lsp +tree-sitter)
       (graphql +lsp)
       (json +lsp +tree-sitter)
       (java +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (julia +lsp +tree-sitter)
       (latex +lsp)
       (lua +lsp)
       (markdown +grip)
       (nix +tree-sitter)
       (org +dragndrop +hugo +pandoc +present +pretty +roam2)
       (php +lsp +tree-sitter)
       (python +lsp +pyenv +pyright +tree-sitter)
       (rest +jq)
       rst
       (ruby +rails +rbenv +lsp +tree-sitter)
       (rust +lsp)
       (sh +lsp +tree-sitter)
       (swift +lsp +tree-sitter)
       (web +lsp +tree-sitter)
       (yaml +lsp)

       :config
       (default +bindings +smartparens))
