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
        'clangd',
        'harper-ls',
        'lua-language-server',
        'pyright',
        'texlab',
      },
    },
  },
}
