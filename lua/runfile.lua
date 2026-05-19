local M = {}

local RUNNERS = {
  c   = 'clang -Wall -Wextra -Wpedantic -o %< % && ./%< && rm %<',
  rs  = 'rustc -o %< % && ./%< && rm %<',
  ml  = 'ocamlc -o %< % && ./%< && rm %< %<.cm*',
  go  = 'go run %',
  py  = 'python %',
  rb  = 'ruby %',
  lua = 'lua %',
  ts  = 'ts-node %',
  sh  = 'sh %'
}

function M.run_file_cmdline()
  local ext = vim.fn.expand('%:e')
  local cmd = RUNNERS[ext]
  if not cmd then
    vim.notify(
      'Unsupported file type: ' .. ext .. '\nSee ~/.config/nvim/lua/runfile.lua',
      vim.log.levels.WARN
    )
    return
  end

  vim.cmd('write')
  vim.cmd('!' .. cmd)
end

function M.run_file_buffer()
  local ext = vim.fn.expand('%:e')
  local cmd = RUNNERS[ext]
  if not cmd then
    vim.notify(
      'Unsupported file type: ' .. ext .. '\nSee ~/.config/nvim/lua/runfile.lua',
      vim.log.levels.WARN
    )
    return
  end

  vim.cmd('write')
  local file        = vim.fn.expand('%')
  local file_no_ext = vim.fn.expand('%:r')
  cmd               = cmd:gsub('%%%<', file_no_ext):gsub('%%', file)

  -- Create output buffer if it doesn't exist
  local buf = vim.fn.bufnr('__output__')
  if buf == - 1 then
    vim.cmd('botright new')
    buf = vim.fn.bufnr()
    vim.api.nvim_buf_set_name(buf, '__output__')
  else
    local win = vim.fn.bufwinid(buf)
    if win == -1 then
      vim.cmd('botright split | buffer ' .. buf)
    else
      vim.fn.win_gotoid(win)
    end
  end

  -- Run command and caputure output
  local output_lines = vim.fn.systemlist(cmd .. ' 2>&1')
  -- Prepend command and blank line
  table.insert(output_lines, 1, '')
  table.insert(output_lines, 1, cmd)
  -- Set buffer content
  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output_lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
end

function M.setup()
  vim.keymap.set(
    'n',
    '<leader>rr',
    function() require("runfile").run_file_cmdline() end,
    { noremap = true, silent = true, desc = '[R]un current file in cmdline' }
  )

  vim.keymap.set(
    'n',
    '<leader>rp',
    function() require("runfile").run_file_buffer() end,
    { noremap = true, silent = true, desc = '[R]un current file in a buffer' }
  )
end

return M
