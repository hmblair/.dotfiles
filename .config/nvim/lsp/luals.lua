local mason = vim.fn.stdpath('data') .. '/mason/bin/'
return {
 cmd = { mason .. 'lua-language-server' },
 filetypes = { 'lua' },
 root_markers = { ".git" },
}
