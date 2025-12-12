return {
  'GCBallesteros/jupytext.nvim',
  lazy = false,
  cond = function()
    if vim.fn.executable('jupytext') == 0 then
      vim.notify('jupytext.nvim: Missing dependency\n  pip3 install jupytext', vim.log.levels.WARN)
      return false
    end
    return true
  end,
  opts = {
    style = 'markdown',
    output_extension = 'md',
    force_ft = 'markdown',
  },
}
