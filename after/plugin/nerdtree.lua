vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Autocmd to close neovim if NERDTree is the only window left
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree then
      vim.cmd("q")
    end
  end
})

vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeRespectWildIgnore = 1
