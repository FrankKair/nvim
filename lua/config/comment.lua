local comment = require('mini.comment')
comment.setup()

local opts = { expr = true, silent = true, desc = 'Toggle comment (CMD+/)' }

vim.keymap.set(
  'n',
  '<D-/>',
  function() return comment.operator() .. '_' end,
  opts
)

vim.keymap.set(
  'x',
  '<D-/>',
  function() return comment.operator() end,
  opts
)
