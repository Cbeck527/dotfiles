" don't bother with vi compatibility
set nocompatible
" configure Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'altercation/vim-colors-solarized'
Plugin 'chase/vim-ansible-yaml'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
Plugin 'gmarik/Vundle.vim'
Plugin 'hashivim/vim-terraform'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mbbill/undotree'
Plugin 'mhinz/vim-signify'
Plugin 'mtth/scratch.vim'
Plugin 'pbrisbin/vim-colors-off'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
call vundle#end()
filetype plugin indent on
set viminfo='100,n$HOME/.vim/files/viminfo

" enable syntax highlighting
syntax enable
" enable syntax checking
let g:syntastic_python_checkers=['pylint']

set autoread                                                 " reload files when changed on disk
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
set wildignore=log/**,node_modules/**,bower_components/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list
set nospell
set noshowmode

" Whitespace
set tabstop=2 shiftwidth=2                    " a tab is two spaces
set expandtab                                 " use spaces, not tabs
set backspace=indent,eol,start                " backspace through everything in insert mode
set colorcolumn=72,99


" keyboard shortcuts
map j gj
map k gk
let mapleader = ','
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nmap <leader>a :Ag<space>
nmap <leader>sc :Scratch<CR>
nmap <leader>cd cdCD
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>t :CtrlP<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gb :Gblame<CR>
nmap <leader>se :Errors<CR>
nmap <leader>sol :ToggleBG<CR>
nmap <leader>u :UndotreeToggle<CR>
nmap <leader>/ :TComment<cr>
vmap <leader>/ :TComment<cr>gv

" buffer fun
nmap <leader>bl :CtrlPBuffer<CR>
nmap <leader>bn :new<CR>
nmap <leader>bvn :vnew<CR>

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

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
" enable :ToggleBG
call togglebg#map("")
" Highlight current line
set cursorline

" Highlight trailing whitespace like an error.
match ErrorMsg '\s\+$'

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

" plugin settings

if has("persistent_undo")
    set undodir=~/.vim/undo/
    set undofile
endif

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0
highlight SignColumn guibg=#073642

" The Silver Searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --ignore bower_components --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_match_window = 'order:ttb,max:25'

" bind K to grep word under cursor
nnoremap K :silent! grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" spell check my git commits
autocmd FileType gitcommit setlocal spell

" markdown specific settings, 80 char width and spellcheck
au BufRead,BufNewFile *.md setlocal textwidth=80 spell colorcolumn=80
au BufRead,BufNewFile *.markdown setlocal textwidth=80 spell colorcolumn=80

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Airline config
let g:airline_powerline_fonts = 1

" Signify config
let g:signify_sign_change = '~'
let g:signify_sign_changedelete = g:signify_sign_change

" MacVim Specific
if has("gui_macvim")
  " No toolbars, menu or scrollbars in the GUI
  set guifont=Inconsolata\ for\ Powerline:h14
  set clipboard+=unnamed
  set vb t_vb=
  set guioptions-=e  "keep tabs in VIM
  set guioptions-=m  "no menu
  set guioptions-=T  "no toolbar
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r  "no scrollbar
  set guioptions-=R

  " Enable basic mouse behavior such as resizing buffers.
  set mouse=a

  " let macvim relax on the whole colorscheme thing
  let macvim_skip_colorscheme = 1

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

  " easier window navigation
  map <C-D-h> <C-w>h
  map <C-D-j> <C-w>j
  map <C-D-k> <C-w>k
  map <C-D-l> <C-w>l

  " indent in insert mode
  imap <D-[> <ESC> <<i
  imap <D-]> <ESC> >>i

  "Open sidebars with cmd
  map <D-k> :NERDTreeToggle<CR>
  map <D-u> :UndotreeToggle<CR>

endif
