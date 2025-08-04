local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
  cmd = { mason .. 'clangd', '--background-index', '--clang-tidy', '--clang-tidy-checks=*', },
  root_markers = { '.git' },
  filetypes = { 'c', 'cpp' },
}
