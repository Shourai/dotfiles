return require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'ray-x/lsp_signature.nvim'

  -- Completion
  use {
      'hrsh7th/nvim-cmp',
      requires = {
          { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
        }
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  -- Treesitter
  use 'nvim-treesitter/nvim-treesitter'

  -- Theme
  use 'NTBBloodbath/doom-one.nvim'
  use 'navarasu/onedark.nvim'

  -- Autopairs
  use 'windwp/nvim-autopairs'

  -- Easy align
  use 'junegunn/vim-easy-align'

  -- Useful plugins
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Modeline
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require'statusline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  -- Tmux
  use {
    "aserowy/tmux.nvim",
    config = function()
      require("tmux").setup({
        copy_sync = {
          enable = true,
          redirect_to_clipboard = true,
          register_offset = 0,
          sync_clipboard = false,
          sync_deletes = true,
        },
        navigation = { enable_default_keybindings = true },
        resize = { enable_default_keybindings = true } })
      end
    }
  end)
