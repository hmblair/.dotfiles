local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
  cmd = { mason .. 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
}
