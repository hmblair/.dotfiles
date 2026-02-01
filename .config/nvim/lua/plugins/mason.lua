return {
  {
    'mason-org/mason.nvim',
    cond = vim.fn.has('nvim-0.11') == 1,
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cond = vim.fn.has('nvim-0.11') == 1,
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        'bash-language-server',
        'harper-ls',
        'lua-language-server',
        'pyright',
        'texlab',
        -- clangd: install via Mason on macOS, or 'apt install clangd' on Linux
      },
    },
  },
}
