" set leader and localleader
let mapleader = ","
let maplocalleader = ","
                 
" =================================================== 
"                 Vim-Plug core 
" ===================================================
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

let g:vim_bootstrap_langs = "python"
let g:vim_bootstrap_editor = "vim"				" nvim or vim

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

" ----------------------------
" ---- customised plugins ----
" ----------------------------

" Use tab for completion
Plug 'ervandew/supertab' 

" colorscheme
Plug 'romainl/flattened'

" Setting the default completion to supertab's 'context' completion
let g:SuperTabDefaultCompletionType = "context"

" " Auto completion for python
" Plug 'davidhalter/jedi-vim' 
" 
" " Don't let docstring window to popup during completion
" autocmd FileType python setlocal completeopt-=preview
" 
" " Don't start autocompletion when typing a dot 
" let g:jedi#popup_on_dot = 0
" 
" " Python in VIM
" Plug 'klen/python-mode' 
" 
" " Avoid overlap in functionality with jedi-vim
" let g:pymode_rope = 0
" 
" " Latex for Vim!
" Plug 'lervag/vimtex' 
" 
" " Set all tex files not as plaintex but as tex 
" let g:tex_flavor='latex'
" 
" " Singleshot compile with latexmk
" nnoremap <leader>ls :VimtexCompileSS!<cr> 
" 
" " Set build directory for LateX
" let g:vimtex_latexmk_build_dir = "build"
" 
" " autocomplete brackets
" Plug 'Raimondi/delimitMate'
" 
" " autocomplete '$' in tex
" au FileType tex let b:delimitMate_quotes = "\" ' $"
" 
" " Syntax checking hacks for vim
" Plug 'scrooloose/syntastic' 
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" 
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" A simple, easy-to-use Vim alignment plugin.
Plug 'junegunn/vim-easy-align'

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" " Ultimate snippets for VIM
" Plug 'SirVer/ultisnips'
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

call plug#end()

" =================================================== 
"                       Shortcuts 
" ===================================================

" Breaking the bad habit of using arrow keys!
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Insert a single character from normal mode
function! RepeatChar(char, count)
   return repeat(a:char, a:count)
endfunction
nnoremap cc :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
nnoremap cl :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>

" Easier movement between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Open new splits
nmap <leader>sh   :leftabove  vnew<cr>
nmap <leader>sl  :rightbelow vnew<cr>
nmap <leader>sk     :leftabove  new<cr>
nmap <leader>sj   :rightbelow new<cr>

" Use tab instead of % for moving between brackets
nnoremap <tab> %
vnoremap <tab> %

" Move a line of text using ALT+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Move a line of text using Command+[jk] on mac (works only on macvim)
if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Move a line of text using ALT+[jk] on mac (works on regular vim)
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Save using <leader>w
nnoremap <leader>w :w <CR> 

" Paste and yank from/to system clipboard
nmap \p "*p
nmap \y "*y

" Compile python shortcut from within vim
nnoremap <silent> <leader>cp :w<CR>:!python %<CR>

" =================================================== 
"                       General 
" ===================================================

" Be iMproved, required
set nocompatible              

" Required
filetype off 

" Backspace also deletes indents
set backspace=indent,eol,start

" Set the size of gvim/macvim window
set lines=30
set columns=120

" Set tabsize
set expandtab tabstop=2
set shiftwidth=2
set softtabstop=2

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" Autosave when focus is lost
:au FocusLost * silent! wa

" Save on buffer switch
set autowriteall

" Autoreload vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" No beeping
set noerrorbells novisualbell
autocmd VimEnter * set vb t_vb=

" Enable mouse
set mouse=a

" Set to auto read when a file is changed from the outside
set autoread

" set persistent undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=10000 
set undoreload=10000

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" =================================================== 
"                       Search 
" ===================================================

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers (incremental search)
set incsearch 

" Remove highlight search results (once)
nmap \h :nohlsearch<CR>

" =================================================== 
"                      Visual 
" ===================================================

" Syntax highlighting
syntax on

" Relative line number
set relativenumber

" Absolute line number (hybrid with relative line number)
set number

" 256 colors
if $TERM == "xterm-256color"
  set t_Co=256
endif

let base16colorspace=256

" Colorscheme
colorscheme flattened_light

" Light background
set background=light

" Set the font for mvim / gvim
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Monospace\ 11
  elseif has("gui_macvim")
    set guifont=Monaco:h11
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

" Remove menubar, toolbar and scrollbar in mvim/gvim
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

" Always show statusline
set laststatus=2

" Statusline config
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" Disable conceal for TeX files
let g:tex_conceal = ""
