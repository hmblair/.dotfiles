local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
    local opts_buffer = { noremap = true, silent = true, buffer = bufnr }
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- [g]oto [t]ype
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts_buffer)

    -- [g]oto [D]eclaration
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts_buffer)

    -- [g]oto [d]efinition
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts_buffer)

    -- [h]over [d]efinition
    vim.keymap.set('n', 'hd', vim.lsp.buf.hover, opts_buffer)

    -- [r]e[n]ame
    vim.keymap.set('n', 're', vim.lsp.buf.rename, opts_buffer)

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts_buffer)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts_buffer)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts_buffer)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts_buffer)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts_buffer)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts_buffer)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts_buffer)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts_buffer)
    vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts_buffer)
end

lspconfig.clangd.setup({
  cmd = { "clangd", "--background-index", "--clang-tidy", "--clang-tidy-checks=*" },
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false,
    on_attach(client, bufnr)
  end,
})

lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
})

vim.lsp.log.set_level(vim.log.levels.OFF)

