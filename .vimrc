" .VIMRC

set nocompatible                                            " This should be the first line. Sets vim to not be backwards compatible with vi.
set encoding=utf-8                                          " Encoding

" Set up vim-plug (https://github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')                           " Location of plugins

Plug 'sheerun/vim-polyglot'                                 " Collection of language packs for Vim
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rrethy/vim-illuminate'                                " Highlights current word
Plug 'dense-analysis/ale'                                   " Ale linting autofixing
Plug 'airblade/vim-gitgutter'                               " Git gutters
Plug 'tpope/vim-fugitive'                                   " Git blame + more
Plug 'embark-theme/vim', { 'as': 'embark' }

call plug#end()

colorscheme embark
"let g:embark_terminal_italics = 1

" FUNCTIONS

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

" VISUALS
syntax enable                                               " Enable Syntax Highlighting
set number                                                  " Enable absolute line numbers
set ruler                                                   " Show the line and column number of the cursor position
set list                                                    " Show invisible characters
set linebreak                                               " Wrap long lines at a character in 'breakat' rather than at the last character that fits on the screen
" List chars
set listchars=""                                            " Reset the listchars
set listchars=tab:\ \                                       " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.                                      " show trailing spaces as dots
set listchars+=extends:>                                    " The character to show in the last column when wrap is
                                                            " off and the line continues beyond the right of the screen
set listchars+=precedes:<                                   " The character to show in the last column when wrap is
                                                            " off and the line continues beyond the left of the screen


if has("statusline") && !&cp
  set laststatus=2                                          " Always show the status bar

  " Start the status line
  set statusline=
  set statusline=\ %f\ %m\ %r
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]

  set statusline+=\ \ \ %=%{GitStatus()}\ %{fugitive#Statusline()}
  set statusline+=%<%h%m%r%=%-5.(%V%)\ %P

endif

" SEARCHING

set hlsearch                                                " highlight matches
set incsearch                                               " incremental searching, search as you type
set ignorecase                                              " searches are case insensitive...
set smartcase                                               " ... unless they contain at least one capital letter


" Disable output, vcs, archive, rails, temp and backup files.
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem          " output and VCS files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz                      " archive files
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/* " bundler and sass cache
set wildignore+=*/venv/*,*/node_modules/*,*/htmlcov/*                        " node_modules, python venv, html cov
set wildignore+=*.swp,*~,._*                                                 " temp and backup files

set backupdir^=~/.vim/_backup//                             " where to put backup files.
set directory^=~/.vim/_temp//                               " where to put swap files.

" Tabbing
filetype plugin indent on                                   " Tabs, indentation and lines
set expandtab                                               " Insert spaces when pressing tab
set tabstop=2                                               " 1 tab = 2 spaces
set softtabstop=2                                           " On backspace, delete a tab instead of 1 space
set shiftwidth=2                                            " Using >> or 'o' or newline in insert mode, set to 2 spaces

set autoindent                                              " Newlines will have the same indentation as previous line

autocmd FileType javascript set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab
autocmd FileType javascriptreact set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab


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

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0

let g:ale_fix_on_save = 1
let g:ale_cache_executable_check_failures = 1
let g:ale_lint_delay=0

" Git Gutter
set updatetime=250
let g:gitgutter_max_signs = 500
" No mapping
let g:gitgutter_map_keys = 0
" Colors
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" Fugitive
nmap <leader>gb :Gblame<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gc :Gcommit<cr>


