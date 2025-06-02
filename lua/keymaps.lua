vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.diagnostic.config({ virtual_text = false })
local function toggle_virtual_text()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
end

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>dt', toggle_virtual_text, { desc = 'Toggle diagnostic virtual text' })

-- CMD+s write/save file
vim.keymap.set("n", "<D-s>", ":w<CR>")

local opts = { noremap = true, silent = true }

-- Window navigation
vim.keymap.set('n', '<c-h>', '<c-w>h', opts)
vim.keymap.set('n', '<c-j>', '<c-w>j', opts)
vim.keymap.set('n', '<c-k>', '<c-w>k', opts)
vim.keymap.set('n', '<c-l>', '<c-w>l', opts)

-- Splits
vim.keymap.set('n', 'vs', ':vs<CR>', opts)
vim.keymap.set('n', 'sp', ':sp<CR>', opts)

-- Buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>', opts)
vim.keymap.set('n', '<leader>w', ':bp <BAR> bd # <CR>', opts)

-- Path (print & copy)
vim.keymap.set('n', '<leader>pp', ":echo expand('%')<CR>", opts)
vim.keymap.set('n', '<leader>cp', ":call system('pbcopy', expand('%'))<CR>", opts)

-- Terminal
vim.keymap.set('n', '<leader>tt', ':vnew term://zsh<CR>', opts)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)

-- Center search results
vim.keymap.set('n', 'n', 'nzz', opts)
vim.keymap.set('n', 'N', 'Nzz', opts)
vim.keymap.set('n', '*', '*zz', opts)
vim.keymap.set('n', '#', '#zz', opts)
vim.keymap.set('n', 'g*', 'g*zz', opts)

-- Clear search highlight on Enter
vim.keymap.set('n', '<CR>', ':nohlsearch<CR>', opts)
