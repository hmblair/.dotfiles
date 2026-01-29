return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup({})
    vim.cmd.colorscheme('tokyonight-night')
    vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = '#f7768e' })
    vim.api.nvim_set_hl(0, 'SpellRare', {})
  end,
}
