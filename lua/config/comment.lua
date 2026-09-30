local opts = { noremap = true, silent = true, desc = 'Toggle comment (CMD+/)' }

vim.keymap.set(
  'n',
  '<D-/>',
  function() require('Comment.api').toggle.linewise.current() end,
  opts
)

vim.keymap.set(
  'v',
  '<D-/>',
  function()
    -- Escape visual mode to apply comment toggle
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
  end,
  opts
)
