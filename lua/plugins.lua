local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
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

require('runfile').setup()
require('translate').setup()
require('leetcode').setup()

require('lazy').setup({
  'tpope/vim-fugitive',
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  { 'lewis6991/gitsigns.nvim', config = function() require('config.gitsigns') end },
  { 'akinsho/bufferline.nvim', config = function() require('config.bufferline') end },
  { 'numToStr/Comment.nvim', config = function()
    require('Comment').setup()
    require('config.comment')
  end },
  { 'folke/which-key.nvim', config = function()
    require('which-key').setup()
    require('config.which_key')
  end },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',             -- Automatically installs LSPs to stdpath
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP status updates
      { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
      'folke/which-key.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function() require('config.lsp') end,
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
    config = function() require('config.cmp') end,
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
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make', -- requires local dependencies to be built
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
    },
    config = function() require('config.telescope') end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    pin = true, -- main needs a separate migration and tree-sitter-cli
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'master', pin = true },
    },
    build = ':TSUpdate',
    config = function() require('config.treesitter') end,
  },
}, {})
