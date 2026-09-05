local opt = vim.opt

opt.wildignore:append({ '*.pyc', '*.o', '*.swp', '*.DS_Store' })
opt.number = true
opt.mouse = 'a'
opt.guicursor = 'n-v-c-sm:block-blinkon100-blinkoff100'
opt.clipboard = 'unnamedplus' -- sync clipboard between OS and nvim
opt.breakindent = true        -- enable break indent
opt.undofile = true           -- save undo history
opt.hlsearch = true           -- highlight search
opt.incsearch = true
opt.ignorecase = true         -- case insensitive search
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250                        -- decrease update time
opt.timeoutlen = 300
opt.completeopt = { 'menuone', 'noselect' } -- better completion experience
opt.termguicolors = true                    -- make sure the terminal supports this
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 15
opt.winborder = 'rounded'

local function set_indent_for(level, languages)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = languages,
    callback = function()
      vim.opt_local.tabstop = level
      vim.opt_local.shiftwidth = level
      vim.opt_local.softtabstop = level
      vim.opt_local.expandtab = true
    end,
  })
end

set_indent_for(4, { 'c', 'cpp', 'go' })
set_indent_for(2, { 'lua', 'perl', 'sh' })
