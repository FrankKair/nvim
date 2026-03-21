vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.diagnostic.config({ virtual_text = false })
local opts = { noremap = true, silent = true }
local map = vim.keymap.set

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local function toggle_virtual_text()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
end

local function toggle_line_numbers()
  vim.wo.number = not vim.wo.number
end

local function open_term()
  vim.cmd.vnew()
  vim.cmd.terminal(vim.o.shell)
end

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Terminal
map('n', '<leader>tt', open_term, { desc = 'Open terminal in vertical split' })
map('t', '<Esc>', '<C-\\><C-n>', opts)
-- Window navigation
map('n', '<c-h>', '<c-w>h', opts)
map('n', '<c-j>', '<c-w>j', opts)
map('n', '<c-k>', '<c-w>k', opts)
map('n', '<c-l>', '<c-w>l', opts)
-- Word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- Toggling
map('n', '<leader>dt', toggle_virtual_text, { desc = 'Toggle diagnostic virtual text' })
map('n', '<leader>ln', toggle_line_numbers, { desc = 'Toggle line numbers' })
-- CMD+s write/save file
map('n', '<D-s>', ':w<CR>', opts)
map('i', '<D-s>', '<Esc>:w<CR>', opts)
-- macOS: CMD+backspace / option+backspace
map('i', '<Esc>[DEL-LINE', '<C-u>', opts)
map('i', '<M-BS>', '<C-w>', opts)
-- Splits
map('n', 'vs', ':vs<CR>', opts)
map('n', 'sp', ':sp<CR>', opts)
-- Buffers
map('n', '<leader><leader>', '<c-^>', opts)
map('n', '<leader>w', ':bp <BAR> bd # <CR>', opts)
-- Path (print & copy)
map('n', '<leader>pp', ":echo expand('%')<CR>", opts)
map('n', '<leader>cp', ":call system('pbcopy', expand('%'))<CR>", opts)
-- Center search results
map('n', 'n', 'nzz', opts)
map('n', 'N', 'Nzz', opts)
map('n', '*', '*zz', opts)
map('n', '#', '#zz', opts)
map('n', 'g*', 'g*zz', opts)
-- Clear search highlight on Enter
map('n', '<CR>', ':nohlsearch<CR>', opts)
