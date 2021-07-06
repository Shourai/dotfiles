-- Map leader to space
vim.g.mapleader = ' '

require('plugins')
require('settings')
require('keymappings')
require('completion')
require('treesitter')
require('telescope')
require('lsp')
require('onedark').setup()
