local M = {}

local function open_leetcode_slug()
  local word = vim.fn.expand('<cWORD>')
  if not word or word == '' then
    vim.notify('No Leetcode slug under cursor', vim.log.levels.WARN)
    return
  end

  local url = 'https://leetcode.com/problems/' .. word .. '/'
  vim.notify('Opening: ' .. url, vim.log.levels.INFO)

  local opener = vim.fn.has('macunix') == 1 and 'open'
      or vim.fn.has('unix') == 1 and 'xdg-open'
      or nil

  if opener then
    os.execute(string.format("%s '%s' &", opener, url))
  else
    vim.notify('No supported URL opener (xdg-open or open)', vim.log.levels.ERROR)
  end
end

function M.setup()
  vim.keymap.set(
    'n',
    '<leader>lc', open_leetcode_slug,
    { desc = 'Open Leetcode problem under cursor', }
  )
end

return M
