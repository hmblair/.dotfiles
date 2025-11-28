return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>fzf', '<cmd>Telescope find_files<CR>', desc = '[F]ind [F]iles' },
    { '<leader>fzg', '<cmd>Telescope live_grep<CR>', desc = '[F]ind by [G]rep' },
    { '<leader>fzb', '<cmd>Telescope buffers<CR>', desc = '[F]ind [B]uffers' },
    { '<leader>fzh', '<cmd>Telescope help_tags<CR>', desc = '[F]ind [H]elp' },
  },
}
