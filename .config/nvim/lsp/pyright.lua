local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
  cmd = { mason .. 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
}
