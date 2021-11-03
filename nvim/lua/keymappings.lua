local map = vim.api.nvim_set_keymap

-- better window movement
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })


-- telescope
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true })
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", { noremap = true })

-- reload init.lua
map("n", "<leader>rc", "<cmd>luafile %<cr>", { noremap = true })
