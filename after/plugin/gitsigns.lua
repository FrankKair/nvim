require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    vim.keymap.set(
      'n',
      '<leader>gp',
      function() require('gitsigns').nav_hunk('prev') end,
      { buffer = bufnr, desc = '[G]o to [P]revious Hunk' }
    )

    vim.keymap.set(
      'n',
      '<leader>gn',
      function() require('gitsigns').nav_hunk('next') end,
      { buffer = bufnr, desc = '[G]o to [N]ext Hunk' }
    )

    vim.keymap.set(
      'n',
      '<leader>ph',
      require('gitsigns').preview_hunk,
      { buffer = bufnr, desc = '[P]review [H]unk' }
    )

    vim.keymap.set(
      'n',
      '<leader>sh',
      require('gitsigns').stage_hunk,
      { buffer = bufnr, desc = '[S]tage [H]unk' }
    )

    vim.keymap.set(
      'n',
      '<leader>rh',
      require('gitsigns').reset_hunk,
      { buffer = bufnr, desc = '[R]eset [H]unk' }
    )
  end,
}
