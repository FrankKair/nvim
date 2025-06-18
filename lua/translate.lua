local M = {}

local function strip_ansi_codes(s)
  return s:gsub('\27%[[0-9;]*m', '')
end

local function lookup_definition(word)
  local handle = io.popen('trans -d "' .. word .. '"')
  if handle then
    local result = handle:read('*a')
    handle:close()
    return strip_ansi_codes(result)
  else
    return 'Failed to open process'
  end
end

local function display_text_in_floating_window(text)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, '\n'))
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.5)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded'
  })
end

function M.define_word()
  local word = vim.fn.expand('<cword>')
  if word == nil or word == '' then
    vim.notify('No word selected or under cursor', vim.log.levels.WARN)
    return
  end
  local definition = lookup_definition(word)
  if definition and #definition > 0 then
    display_text_in_floating_window(definition)
  else
    vim.notify('No definition found', vim.log.levels.INFO)
  end
end

function M.setup()
  vim.keymap.set(
    'n',
    '<leader>lw',
    function() require('translate').define_word() end,
    { noremap = true, silent = true, desc = '[L]ookup [w]ord' }
  )
end

return M
