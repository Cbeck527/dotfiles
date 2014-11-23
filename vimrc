" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

" let macvim relax on the whole colorscheme thing
let macvim_skip_colorscheme = 1

set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory=~/.vim/swap,~/tmp,.                            " don't store swapfiles in the current directory
set encoding=utf-8
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline - CHANGE FOR POWERLINE
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:·
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set showcmd
set smartcase                                                " case-sensitive search if any caps
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list
set nospell
set noshowmode

" Whitespace
set tabstop=2 shiftwidth=2                    " a tab is two spaces
set expandtab                                 " use spaces, not tabs
set backspace=indent,eol,start                " backspace through everything in insert mode
set colorcolumn=99

" Enable basic mouse behavior such as resizing buffers.
set mouse=a

" keyboard shortcuts
let mapleader = ','
nmap <leader>a :Ag<space>
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>cd cdCD
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
map <Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
nmap <leader>t :CtrlP<CR>
nmap <leader>r :CtrlPBuffer<CR>
nmap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gb :Gblame<CR>
nmap <leader>/ :TComment<cr>
vmap <leader>/ :TComment<cr>gv
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" search settings
set hlsearch
nmap <leader>hl :let @/ = ""<CR>

" color scheme
colorscheme solarized
set bg=dark
" Highlight current line
set cursorline

" Highlight trailing whitespace like an error.
match ErrorMsg '\s\+$'

" in case you forgot to sudo
cmap w!! %!sudo tee > /dev/null %

" maps control backspace like I'm used to
cmap <A-BS> <C-W>

" yanks lines like D and C funciton
nnoremap Y y$

" split the intuitive way
set splitbelow
set splitright

" pls
nnoremap <F1> <nop>
nnoremap Q <nop>
nnoremap K <nop>

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:25'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0
highlight SignColumn guibg=#073642

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" spell check my git commits
autocmd FileType gitcommit setlocal spell

" markdown specific settings, 80 char width and spellcheck
au BufRead,BufNewFile *.md setlocal textwidth=80 spell
au BufRead,BufNewFile *.markdown setlocal textwidth=80 spell

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Python
let g:khuno_max_line_length=99
nmap <silent><Leader>e <Esc>:Khuno show<CR>

" MacVim Specific
if has("gui_macvim")
  " No toolbars, menu or scrollbars in the GUI
  let g:airline_powerline_fonts = 1
  set guifont=Inconsolata\ for\ Powerline:h14
  set clipboard+=unnamed
  set vb t_vb=
  set guioptions-=m  "no menu
  set guioptions-=T  "no toolbar
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r  "no scrollbar
  set guioptions-=R

  " exit insert when lost focus
  au FocusLost,TabLeave * call feedkeys("\<C-\>\<C-n>")

  " Comment lines with cmd+/
  map <D-/> :TComment<cr>
  vmap <D-/> :TComment<cr>gv

  " Indent lines with cmd+[ and cmd+]
  nmap <D-]> >>
  nmap <D-[> <<
  vmap <D-[> <gv
  vmap <D-]> >gv

  "Open sidebar with cmd+k
  map <D-k> :NERDTreeToggle<CR>

  " This mapping makes Ctrl-Tab switch between tabs.
  " Ctrl-Shift-Tab goes the other way.
  noremap <C-Tab> :tabnext<CR>
  noremap <C-S-Tab> :tabprev<CR>

  " switch between tabs with cmd+1, cmd+2,..."
  map <D-1> 1gt
  map <D-2> 2gt
  map <D-3> 3gt
  map <D-4> 4gt
  map <D-5> 5gt
  map <D-6> 6gt
  map <D-7> 7gt
  map <D-8> 8gt
  map <D-9> 9gt

  " until we have default MacVim shortcuts this is the only way to use it in
  " insert mode
  imap <D-1> <esc>1gt
  imap <D-2> <esc>2gt
  imap <D-3> <esc>3gt
  imap <D-4> <esc>4gt
  imap <D-5> <esc>5gt
  imap <D-6> <esc>6gt
  imap <D-7> <esc>7gt
  imap <D-8> <esc>8gt
  imap <D-9> <esc>9gt

  " Select text whit shift
  let macvim_hig_shift_movement = 1

endif
