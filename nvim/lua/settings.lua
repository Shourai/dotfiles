--- Helpers ---
local cmd = vim.cmd
local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- Settings --
o.backup = false -- don't create backup file
o.clipboard = "unnamedplus" -- allow neovim to access the system clipboard
o.completeopt = "menuone,noselect"
wo.conceallevel = 0 -- so that `` is visible in markdown files
bo.fileencoding = "utf-8" -- the encoding written to a file
o.ignorecase = true -- ignore case in search pattern
o.smartcase = true -- smart case
o.mouse = "a" -- allow the mouse to be used in neovim

o.splitbelow = true -- force all horizontal splits to go below current window
o.splitright = true -- force all vertical splits to go to the right of current window

bo.swapfile = false -- creates a swapfile
bo.expandtab = true -- convert tabs to spaces
bo.tabstop = 2
bo.shiftwidth = 2

wo.cursorline = true -- highlight the current line
wo.number = true  -- set numbered lines
wo.relativenumber = true -- set relative numbered lines

cmd("autocmd FocusLost * silent! :wa") -- write file when focus is lost
o.autowriteall = true -- write the contents of the file when jumping between jumppoints

bo.undofile = true

cmd("autocmd BufWritePost plugins.lua PackerCompile") -- automatically run PackerCompile when changes to plugins.lua has been made
