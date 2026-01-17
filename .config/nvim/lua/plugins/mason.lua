return {
  'mason-org/mason.nvim',
  cond = vim.fn.has('nvim-0.11') == 1,
  opts = {
    ensure_installed = {
      'bash-language-server',
      'clangd',
      'lua_ls',
      'pyright',
      'texlab',
    },
  },
}
