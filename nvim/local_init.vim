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

" Split to right and bottom
set splitbelow
set splitright

" So that `` is displayed in markdown files
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

" folding config
set foldlevelstart=10

" yaml settings
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" golang settings
" set tmpl files as gotexttmpl filetype
autocmd BufNewFile,BufRead *.tmpl set ft=gotexttmpl

" Telescope keybindings
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Lsp key bindings
" NOTE: Use command ':verbose imap <C-f>' to make sure tab is not mapped by other plugins
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K     <cmd>Lspsaga hover_doc<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-p> <cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <C-n> <cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gn    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ga    <cmd>Lspsaga code_action<CR>
xnoremap <silent> ga    <cmd>Lspsaga range_code_action<CR>
nnoremap <silent> gs    <cmd>Lspsaga signature_help<CR>

lua <<EOF
require("lsp")
require("completion")
require("telescope")
require("treesitter")
EOF

" vim ledger settings
nmap <C-c><C-a> :call ledger#transaction_date_set(line('.'), "auxiliary")

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
