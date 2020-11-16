" Always autosave everything
au FocusLost * silent! :wa
set autowriteall
set relativenumber
set clipboard+=unnamedplus

" Colorscheme settings
let g:airline_powerline_fonts = 1
let g:airline_theme='onedark'
colorscheme onedark

" Set transparant background vim
"hi Normal guibg=NONE ctermbg=NONE

" Show replace as you type
set inccommand=nosplit

" Change onedark's visual highlight
hi Visual guibg=#626672

" So that I can see `` in markdown files
let g:indentLine_fileTypeExclude = ['markdown']

set smarttab
set smartindent
set cursorline

set tabstop=2
set shiftwidth=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" Delimitemate settings
let delimitMate_expand_cr = 2
imap <C-j> <Plug>delimitMateS-Tab
imap <C-l> <Plug>delimitMateJumpMany

" CoC settings
let g:coc_explorer_global_presets = {
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   }}

nmap <space>fe :CocCommand explorer --preset floating<CR>
nmap <space>e :CocCommand explorer<CR>

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <C-f> to confirm completion
" NOTE: Use command ':verbose imap <C-f>' to make sure tab is not mapped by
" other plugins
inoremap <expr> <C-f> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" folding config
set foldlevelstart=2

" tmux settings

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
"endif
