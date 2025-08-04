local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
 cmd = { mason .. 'bash-language-server' },
 filetypes = { 'sh', 'zsh' },
 root_markers = { ".git" },
}
