local mason_clangd = vim.fn.stdpath('data') .. '/mason/bin/clangd'
local clangd = vim.fn.executable(mason_clangd) == 1 and mason_clangd or 'clangd'
return {
  cmd = { clangd, '--background-index', '--clang-tidy', '--clang-tidy-checks=*' },
  root_markers = { '.git' },
  filetypes = { 'c', 'cpp' },
}
