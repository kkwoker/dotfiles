" .VIMRC

set nocompatible                                            " This should be the first line. Sets vim to not be backwards compatible with vi.
set encoding=utf-8                                          " Encoding

" Set up vim-plug (https://github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')                           " Location of plugins

Plug 'sheerun/vim-polyglot'                                 " Collection of language packs for Vim
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rrethy/vim-illuminate'                                " Highlights current word
Plug 'davidhalter/jedi-vim'                                 " Autocompletes and goto definitions
Plug 'dense-analysis/ale'                                   " Ale linting autofixing
Plug 'airblade/vim-gitgutter'                               " Git gutters

call plug#end()

" FUNCTIONS

" VISUALS
syntax enable                                               " Enable Syntax Highlighting
set number                                                  " Enable absolute line numbers
set ruler                                                   " Show the line and column number of the cursor position
set rulerformat=L%l,C%c%V%=%P


" Disable output, vcs, archive, rails, temp and backup files.
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*


" Tabbing
filetype plugin indent on                                   " Tabs, indentation and lines
set expandtab                                               " Insert spaces when pressing tab
set tabstop=2                                               " 1 tab = 2 spaces
set softtabstop=2                                           " On backspace, delete a tab instead of 1 space
set shiftwidth=2                                            " Using >> or 'o' or newline in insert mode, set to 2 spaces

set autoindent                                              " Newlines will have the same indentation as previous line

" Folding
set foldmethod=indent
set foldclose=""

" Handy
set autoread                                                " Reload unchanged files automatically.
noremap :W :w                                               " Maps :W to :w (https://stackoverflow.com/questions/10590165/is-there-a-way-in-vim-to-make-w-to-do-the-same-thing-as-w)

set wildmenu
set wildmode=longest,full                                   " For autocompletion, complete as much as you can.
set mouse=a                                                 " Enable mouse for scrolling and window resizing. (MINDBLOWING.)
set noswapfile                                              " Disable swap to prevent annoying messages

" UNDO FILE
if !isdirectory("/tmp/.vim-undo-dir")
  call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undofile                                                " Stores undo history even when file is closed
set undodir=/tmp/.vim-undo-dir


if &shell =~# 'fish$'                                       " Avoid problems with fish shell. (I just saw this, not sure what it does)
  set shell=/bin/bash
endif


" PLUGIN CONFIGURATIONS
" NERDTree
nmap <leader>n :NERDTreeToggle<cr>                           " Normal mode map <leader>n to toggle NERDTree

" Ctrl-P
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor                      " Use ag over grep
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'     " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_use_caching = 0                               " ag is fast enough that CtrlP doesn't need to cache
endif

" vim-illuminate
let g:Illuminate_delay = 0                                  " Highlight the words immediately
hi link illuminatedWord Visual                              " Instead of underline, highlight in shade

" vim-jedi
let g:jedi#use_tabs_not_buffers = 1                         " Opens a tab when going to definitions

" Ale Linter
let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier', 'eslint']

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0

let g:ale_fix_on_save = 1

