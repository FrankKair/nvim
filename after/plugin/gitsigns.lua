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
      '<leader>hb',
      function() require('gitsigns').nav_hunk('prev') end,
      { buffer = bufnr, desc = '[H]unk [B]ack (previous)' }
    )

    vim.keymap.set(
      'n',
      '<leader>hn',
      function() require('gitsigns').nav_hunk('next') end,
      { buffer = bufnr, desc = '[H]unk [N]ext' }
    )

    vim.keymap.set(
      'n',
      '<leader>hp',
      require('gitsigns').preview_hunk,
      { buffer = bufnr, desc = '[H]unk [P]review' }
    )

    vim.keymap.set(
      'n',
      '<leader>hs',
      require('gitsigns').stage_hunk,
      { buffer = bufnr, desc = '[H]unk [S]tage' }
    )

    vim.keymap.set(
      'n',
      '<leader>hr',
      require('gitsigns').reset_hunk,
      { buffer = bufnr, desc = '[H]unk [R]eset' }
    )
  end,
}
