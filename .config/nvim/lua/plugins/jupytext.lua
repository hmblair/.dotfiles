return {
  'GCBallesteros/jupytext.nvim',
  event = 'BufReadCmd *.ipynb',
  config = function()
    if vim.fn.executable('jupytext') == 0 then
      vim.notify('jupytext.nvim: Missing dependency\n  pip3 install jupytext', vim.log.levels.WARN)
      return
    end
    require('jupytext').setup({
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    })
  end,
}
