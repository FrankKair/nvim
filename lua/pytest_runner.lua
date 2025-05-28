-- Python Test Runner for Neovim
-- A simple package for running pytest at different scopes

local M = {}

-- Global terminal buffer number to ensure we always reuse the same terminal
local term_buf = nil
local term_win = nil
-- Store the original window to return to after running tests
local original_win = nil

-- Helper function to run command in terminal - ALWAYS reuses the same terminal
local function run_in_terminal(command)
  original_win = vim.api.nvim_get_current_win()

  if term_buf ~= nil and not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = nil
    term_win = nil
  end

  -- Look for an existing terminal buffer if we don't have one yet
  if term_buf == nil then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "terminal" then
        term_buf = buf
        break
      end
    end
  end

  -- If we have a terminal buffer, try finding if it's visible in any window
  if term_buf ~= nil then
    local is_visible = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == term_buf then
        term_win = win
        is_visible = true
        break
      end
    end

    -- Terminal exists but isn't visible, make it visible
    if not is_visible then
      -- Create a split and set the buffer
      vim.cmd("vsplit")
      -- Make sure the buffer is still valid before setting it
      if vim.api.nvim_buf_is_valid(term_buf) then
        vim.api.nvim_win_set_buf(0, term_buf)
        term_win = vim.api.nvim_get_current_win()
      else
        -- Buffer is no longer valid, create a new terminal
        term_buf = nil
        vim.cmd("terminal")
        term_buf = vim.api.nvim_get_current_buf()
        term_win = vim.api.nvim_get_current_win()
      end
    else
      -- Terminal is visible, so focus it
      if vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_set_current_win(term_win)
      else
        -- Window is no longer valid, create a new terminal
        vim.cmd("vsplit | terminal")
        term_buf = vim.api.nvim_get_current_buf()
        term_win = vim.api.nvim_get_current_win()
      end
    end

    -- Send command to terminal
    local job_id = vim.b[term_buf].terminal_job_id
    if job_id then
      vim.cmd("startinsert")
      vim.opt_local.scrollback = 100000
      vim.api.nvim_chan_send(job_id, command .. "\n")

      -- Return to original window after a short delay
      vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(original_win) then
          vim.api.nvim_set_current_win(original_win)
          -- Force normal mode when returning to editor
          vim.cmd("stopinsert")
        end
      end, 100)
    else
      -- Terminal job has died, create a new one in the same buffer
      vim.cmd(string.format("buffer %d | %s", term_buf, "terminal"))
      vim.cmd("startinsert")

      -- Give terminal time to initialize then send command
      vim.defer_fn(function()
        local job_id = vim.b[term_buf].terminal_job_id
        if job_id then
          vim.api.nvim_chan_send(job_id, command .. "\n")

          -- Return to original window after a short delay
          vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(original_win) then
              vim.api.nvim_set_current_win(original_win)
              -- Force normal mode when returning to editor
              vim.cmd("stopinsert")
            end
          end, 100)
        end
      end, 100)
    end
  else
    -- No terminal exists yet, create one
    vim.cmd("vsplit | terminal")
    term_buf = vim.api.nvim_get_current_buf()
    term_win = vim.api.nvim_get_current_win()

    -- Set terminal options
    vim.opt_local.scrollback = 100000

    -- Give terminal time to initialize then send command
    vim.defer_fn(function()
      local job_id = vim.b[term_buf].terminal_job_id
      if job_id then
        vim.cmd("startinsert")
        vim.api.nvim_chan_send(job_id, command .. "\n")

        -- Return to original window after a short delay
        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(original_win) then
            vim.api.nvim_set_current_win(original_win)
            -- Force normal mode when returning to editor
            vim.cmd("stopinsert")
          end
        end, 100)
      end
    end, 100)
  end
end

local function is_in_test_file()
  local filename = vim.fn.expand("%:t")
  return string.match(filename, "^test_.*%.py$") or string.match(filename, ".*_test%.py$")
end

local function setup_terminal_options()
  local group = vim.api.nvim_create_augroup("PytestTerminalOptions", { clear = true })

  vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.scrollback = 100000
      vim.opt_local.bufhidden = "hide"
    end
  })
end

function M.run_test_function()
  local bufname = vim.fn.expand("%:p")
  if not is_in_test_file() then
    vim.notify("Not in a test file", vim.log.levels.WARN)
    return
  end

  local parser = vim.treesitter.get_parser(0, "python")
  if not parser then
    vim.notify("Python treesitter parser not available", vim.log.levels.ERROR)
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  cursor_row = cursor_row - 1 -- Treesitter is 0-indexed

  local function_node = nil
  local function find_function_at_cursor(node)
    if node:type() == "function_definition" then
      local start_row, start_col, end_row, end_col = node:range()
      if cursor_row >= start_row and cursor_row <= end_row then
        -- Check if any child is an "identifier" to get the function name
        for child in node:iter_children() do
          if child:type() == "identifier" then
            function_node = node
            return true
          end
        end
      end
    end

    for child in node:iter_children() do
      if find_function_at_cursor(child) then
        return true
      end
    end

    return false
  end

  find_function_at_cursor(root)

  if not function_node then
    vim.notify("No test function found at cursor position", vim.log.levels.WARN)
    return
  end

  local function_name = nil
  for child in function_node:iter_children() do
    if child:type() == "identifier" then
      function_name = vim.treesitter.get_node_text(child, 0)
      break
    end
  end

  if not function_name or not string.match(function_name, "^test_") then
    vim.notify("Not inside a test function (should start with 'test_')", vim.log.levels.WARN)
    return
  end

  local cmd = string.format("uv run python -m pytest -s %s::%s -vv", bufname, function_name)
  vim.notify("Running: " .. cmd, vim.log.levels.INFO)
  run_in_terminal(cmd)
end

function M.run_test_module()
  local bufname = vim.fn.expand("%:p")
  if not is_in_test_file() then
    vim.notify("Not in a test file", vim.log.levels.WARN)
    return
  end

  local cmd = string.format("uv run python -m pytest -s %s -vv", bufname)
  vim.notify("Running all tests in module: " .. bufname, vim.log.levels.INFO)
  run_in_terminal(cmd)
end

function M.run_test_path()
  local current_dir = vim.fn.expand("%:p:h")
  local cmd = string.format("uv run python -m pytest -s %s -vv", current_dir)
  vim.notify("Running all tests in path: " .. current_dir, vim.log.levels.INFO)
  run_in_terminal(cmd)
end

function M.run_all_tests()
  local tests_dir = vim.fn.finddir("tests", ".;")
  if tests_dir == "" then
    tests_dir = vim.fn.finddir("test", ".;")
  end

  if tests_dir == "" then
    tests_dir = "."
  end

  tests_dir = vim.fn.fnamemodify(tests_dir, ":p")
  local cmd = string.format("uv run python -m pytest -s %s -vv", tests_dir)
  vim.notify("Running all tests in: " .. tests_dir, vim.log.levels.INFO)
  run_in_terminal(cmd)
end

-- Set up keybindings
function M.setup(opts)
  opts = opts or {}

  local keymaps = opts.keymaps or {
    test_function = "<leader>tf",
    test_module = "<leader>tm",
    test_path = "<leader>tp",
    test_all = "<leader>ta"
  }

  setup_terminal_options()

  -- Create keymaps
  vim.api.nvim_set_keymap(
    "n",
    keymaps.test_function,
    [[<cmd>lua require('pytest_runner').run_test_function()<CR>]],
    { noremap = true, silent = true, desc = "Run test function under cursor" }
  )

  vim.api.nvim_set_keymap(
    "n",
    keymaps.test_module,
    [[<cmd>lua require('pytest_runner').run_test_module()<CR>]],
    { noremap = true, silent = true, desc = "Run all tests in current module" }
  )

  vim.api.nvim_set_keymap(
    "n",
    keymaps.test_path,
    [[<cmd>lua require('pytest_runner').run_test_path()<CR>]],
    { noremap = true, silent = true, desc = "Run all tests in current path" }
  )

  vim.api.nvim_set_keymap(
    "n",
    keymaps.test_all,
    [[<cmd>lua require('pytest_runner').run_all_tests()<CR>]],
    { noremap = true, silent = true, desc = "Run all tests" }
  )
end

return M
