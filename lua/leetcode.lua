local M = {}

local function open_leetcode_slug()
  local word = vim.fn.expand('<cWORD>')
  if not word or word == '' then
    vim.notify('No Leetcode slug under cursor', vim.log.levels.WARN)
    return
  end

  if not word:match('^[%w%-]+$') then
    vim.notify('Invalid LeetCode slug: ' .. word, vim.log.levels.WARN)
    return
  end

  local url = 'https://leetcode.com/problems/' .. word .. '/'
  vim.notify('Opening: ' .. url, vim.log.levels.INFO)

  local ok, err = vim.ui.open(url)
  if not ok then vim.notify('Could not open URL: ' .. tostring(err), vim.log.levels.ERROR) end
end

function M.setup()
  vim.keymap.set(
    'n',
    '<leader>lc', open_leetcode_slug,
    { desc = 'Open Leetcode problem under cursor', }
  )
end

return M
