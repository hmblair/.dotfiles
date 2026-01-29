local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
  cmd = { mason .. 'harper-ls', '--stdio' },
  filetypes = { 'markdown', 'text', 'gitcommit' },
  root_markers = { '.git' },
  single_file_support = true,
  settings = {
    ['harper-ls'] = {
      diagnosticSeverity = 'warning',
      linters = {
        long_sentences = false,
        sentence_capitalization = true,
      },
    },
  },
}
