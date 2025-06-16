local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local function smart_goto_definition()
    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, _, _)
      if result == nil or vim.tbl_isempty(result) then
        print('No definition found')
        return
      end
      if #result == 1 then
        vim.lsp.util.show_document(result[1], 'utf-8')
      else
        require('telescope.builtin').lsp_definitions()
      end
    end)
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', smart_goto_definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  vim.api.nvim_buf_create_user_command(
    bufnr,
    'Format',
    function(_) vim.lsp.buf.format() end,
    { desc = 'Format current buffer with LSP' }
  )
end

require('which-key').setup({
  { '<leader>c',  group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d',  group = '[D]ocument' },
  { '<leader>d_', hidden = true },
  { '<leader>g',  group = '[G]it' },
  { '<leader>g_', hidden = true },
  { '<leader>h',  group = 'Git [H]unk' },
  { '<leader>h_', hidden = true },
  { '<leader>r',  group = '[R]ename' },
  { '<leader>r_', hidden = true },
  { '<leader>s',  group = '[S]earch' },
  { '<leader>s_', hidden = true },
  { '<leader>t',  group = '[T]oggle' },
  { '<leader>t_', hidden = true },
  { '<leader>w',  group = '[W]orkspace' },
  { '<leader>w_', hidden = true },
})
require('which-key').setup({
  { '<leader>',  group = 'VISUAL <leader>', mode = 'v' },
  { '<leader>h', desc = 'Git [H]unk',       mode = 'v' },
})

local servers = {
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

require('neodev').setup()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.offsetEncoding = { 'utf-8' }
require('mason').setup()
require('mason-lspconfig').setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup { ensure_installed = vim.tbl_keys(servers) }

vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = on_attach
})
