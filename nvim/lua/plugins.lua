return require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- LSP and completion
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  use 'ray-x/lsp_signature.nvim'

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
  use 'airblade/vim-gitgutter'

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
        navigation = { enable_default_keybindings = true },
        resize = { enable_default_keybindings = true } })
      end
    }
  end)
