local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
  cmd = { mason .. 'pylsp' },
  root_markers = { '.git' },
  filetypes = { 'python' },
}
