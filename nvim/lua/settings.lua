-- Settings --
-- See :h lua-vim-opt

vim.opt.backup = false -- don't create backup file
vim.opt.clipboard = "unnamed,unnamedplus" -- allow neovim to access the system clipboard
vim.opt.completeopt = "menuone,noselect"
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.ignorecase = true -- ignore case in search pattern
vim.opt.smartcase = true -- smart case
vim.opt.mouse = "a" -- allow the mouse to be used in neovim

vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window

vim.opt.swapfile = false -- creates a swapfile
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true  -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.termguicolors = true -- Enables 24 bit RGB colors in the TUI
vim.opt.inccommand = "nosplit"

vim.cmd("autocmd FocusLost * silent! :wa") -- write file when focus is lost
vim.opt.autowriteall = true -- write the contents of the file when jumping between jumppoints

vim.opt.undofile = true

vim.cmd("autocmd BufWritePost plugins.lua PackerCompile") -- automatically run PackerCompile when changes to plugins.lua has been made
