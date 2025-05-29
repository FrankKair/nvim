local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('pytest_runner').setup()
require('runfile').setup()
require('lazy').setup({
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'lewis6991/gitsigns.nvim',
  'preservim/nerdtree',
  'akinsho/bufferline.nvim',
  { 'numToStr/Comment.nvim', opts = {} }, -- "gc" to comment regions/lines
  { 'folke/which-key.nvim',  opts = {} }, -- Shows pending keybinds
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',          -- Automatically installs LSPs to stdpath
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP status updates
      'folke/neodev.nvim',                -- Additional Lua configuration
    },
  },
  {
    'hrsh7th/nvim-cmp',               -- Autocompletion
    dependencies = {
      'L3MON4D3/LuaSnip',             -- Snippet engine & its associated nvim-cmp source
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',         -- LSP completion capabilities
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets', -- User-friendly snippets
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make', -- requires local dependencies to be built
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
}, {})
