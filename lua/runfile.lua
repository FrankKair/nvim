local M = {}

local interpreters = {
  go = { 'go', 'run' }, py = { 'python' }, rb = { 'ruby' },
  lua = { 'lua' }, pl = { 'perl' }, ts = { 'ts-node' }, sh = { 'sh' },
}
local compilers = {
  c = { 'clang', '-Wall', '-Wextra', '-Wpedantic', '-o' },
  rs = { 'rustc', '-o' }, ml = { 'ocamlc', '-o' },
}
local run_id = 0

local function current_source()
  local source = vim.api.nvim_buf_get_name(0)
  local ext = vim.fn.fnamemodify(source, ':e')
  if not interpreters[ext] and not compilers[ext] then
    vim.notify('Unsupported file type: ' .. ext .. '\nSee lua/runfile.lua', vim.log.levels.WARN)
    return nil
  end
  if source == '' then
    vim.notify('Save the file before running it', vim.log.levels.WARN)
    return nil
  end
  vim.cmd('write')
  return source, ext
end

local function output_buffer()
  local buf = vim.fn.bufnr('__output__')
  if buf == -1 then
    vim.cmd('botright new')
    buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(buf, '__output__')
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].swapfile = false
  elseif vim.fn.bufwinid(buf) == -1 then
    vim.cmd('botright split')
    vim.api.nvim_win_set_buf(0, buf)
  else
    vim.api.nvim_set_current_win(vim.fn.bufwinid(buf))
  end
  return buf
end

local function show(buf, lines)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

local function report(buf, phase, result)
  local lines = { phase .. ' exited with code ' .. result.code, '' }
  local stdout, stderr = result.stdout or '', result.stderr or ''
  local output = stdout .. (stdout ~= '' and stderr ~= '' and not stdout:match('\n$') and '\n' or '') .. stderr
  vim.list_extend(lines, vim.split(output:gsub('\n$', ''), '\n', { plain = true }))
  if buf then
    show(buf, lines)
  else
    vim.api.nvim_echo({ { table.concat(lines, '\n') } }, true, {})
  end
  if result.code ~= 0 then
    vim.notify(phase .. ' failed (exit ' .. result.code .. ')', vim.log.levels.ERROR)
  end
end

local function start(source, ext, buf)
  local cwd = vim.fs.dirname(source)
  local id = run_id + 1
  run_id = id
  if buf then show(buf, { 'Running ' .. source .. ' ...' }) end

  local tempdir
  local function finish(phase, result)
    if tempdir then vim.fn.delete(tempdir, 'rf') end
    if id == run_id then report(buf, phase, result) end
  end
  local function launch(argv, directory, callback)
    local ok, err = pcall(vim.system, argv, { cwd = directory, text = true }, function(result)
      vim.schedule(function() callback(result) end)
    end)
    if not ok then callback({ code = 1, stdout = '', stderr = tostring(err) }) end
  end

  if interpreters[ext] then
    local argv = vim.list_extend(vim.deepcopy(interpreters[ext]), { source })
    launch(argv, cwd, function(result) finish('Run', result) end)
    return
  end

  local build_dir = vim.fn.tempname()
  if vim.fn.mkdir(build_dir) ~= 1 then
    finish('Preparation', { code = 1, stderr = 'Could not create temporary build directory' })
    return
  end
  tempdir = build_dir
  local local_source = tempdir .. '/' .. vim.fs.basename(source)
  local copied, copy_error = vim.uv.fs_copyfile(source, local_source)
  if not copied then
    finish('Preparation', { code = 1, stderr = 'Could not copy source: ' .. tostring(copy_error) })
    return
  end
  local binary = tempdir .. '/runfile-output'
  local argv = vim.list_extend(vim.deepcopy(compilers[ext]), { binary, local_source })
  launch(argv, tempdir, function(result)
    if result.code ~= 0 then
      finish('Compile', result)
      return
    end
    launch({ binary }, cwd, function(run_result) finish('Run', run_result) end)
  end)
end

function M.run_file_cmdline()
  local source, ext = current_source()
  if source then start(source, ext) end
end

function M.run_file_buffer()
  local source, ext = current_source()
  if source then start(source, ext, output_buffer()) end
end

function M.setup()
  vim.keymap.set('n', '<leader>rr', M.run_file_cmdline,
    { silent = true, desc = '[R]un current file in cmdline' })
  vim.keymap.set('n', '<leader>rp', M.run_file_buffer,
    { silent = true, desc = '[R]un current file in a buffer' })
end

return M
