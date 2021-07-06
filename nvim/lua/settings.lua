--- Helpers ---
local cmd = vim.cmd
local opt = vim.opt

-- Settings --
opt.backup = false -- don't create backup file
opt.clipboard = "unnamedplus" -- allow neovim to access the system clipboard
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.ignorecase = true -- ignore case in search pattern
opt.smartcase = true -- smart case
opt.mouse = "a" -- allow the mouse to be used in neovim

opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window

opt.swapfile = false -- creates a swapfile
opt.expandtab = true -- convert tabs to spaces
opt.tabstop = 2
opt.shiftwidth = 2

opt.cursorline = true -- highlight the current line

opt.number = true  -- set numbered lines
opt.relativenumber = true -- set relative numbered lines

vim.api.nvim_command("autocmd FocusLost * silent! :wa") -- write file when focus is lost
opt.autowriteall = true -- write the contents of the file when jumping between jumppoints
