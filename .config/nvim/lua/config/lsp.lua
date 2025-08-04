-- Disable logging
vim.lsp.log.set_level(vim.log.levels.OFF)

-- Enable LSPs
vim.lsp.enable({ 'pyright', 'clangd', 'bashls', 'luals'})

-- Enable completion menus
vim.api.nvim_create_autocmd('LspAttach', {

  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local methods = vim.lsp.protocol.Methods
    vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'popup' }
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end,

})

--
-- LSP key bindings
--

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
