return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup({
      on_highlights = function(hl, c)
        hl.SpellBad = { undercurl = true, sp = c.red }
        hl.SpellRare = {}
      end,
    })
    vim.cmd.colorscheme('tokyonight-night')
  end,
}
