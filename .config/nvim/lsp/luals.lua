local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
  cmd = { mason .. 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { ".git" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
