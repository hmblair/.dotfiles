return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local opts = function(desc)
        return { buffer = bufnr, desc = desc }
      end

      -- Navigation
      vim.keymap.set('n', ']h', gs.next_hunk, opts('Next hunk'))
      vim.keymap.set('n', '[h', gs.prev_hunk, opts('Previous hunk'))

      -- Actions
      vim.keymap.set('n', '<leader>hs', gs.stage_hunk, opts('Stage hunk'))
      vim.keymap.set('n', '<leader>hr', gs.reset_hunk, opts('Reset hunk'))
      vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, opts('Stage hunk'))
      vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, opts('Reset hunk'))
      vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, opts('Undo stage hunk'))
      vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts('Preview hunk'))
      vim.keymap.set('n', '<leader>hb', function() gs.blame_line({ full = true }) end, opts('Blame line'))
      vim.keymap.set('n', '<leader>hd', gs.diffthis, opts('Diff this'))
    end,
  },
}
