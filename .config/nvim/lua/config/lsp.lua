-- Disable logging
vim.lsp.log.set_level(vim.log.levels.DEBUG)

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '󰌶',
      [vim.diagnostic.severity.INFO] = '●',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = {
    prefix = "✘",
    severity = vim.diagnostic.severity.ERROR,
  },
  float = {
    border = 'rounded',
    -- prefix = "",
  },
})



local function _attach_lsp_bindings(bufnr)

  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show [e]rror in floating window', silent = true })
  -- [j]ump to [e]rror
  vim.keymap.set('n', 'je', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
  end, { buffer = bufnr })
  vim.keymap.set('n', 'Je', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
  end, { buffer = bufnr })
  -- [j]ump to [w]arning
  vim.keymap.set('n', 'jw', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
  end, { buffer = bufnr })
  vim.keymap.set('n', 'Jw', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
  end, { buffer = bufnr })
  -- [g]oto [t]ype
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = bufnr })
  -- [g]oto [D]eclaration
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
  -- [g]oto [d]efinition
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  -- [g]oto [reference]
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
  -- [g]oto implementation
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
  -- [h]over [d]efinition
  vim.keymap.set('n', 'hd', vim.lsp.buf.hover, { buffer = bufnr })
  -- [r]e[n]ame
  vim.keymap.set('n', 're', vim.lsp.buf.rename, { buffer = bufnr })
  -- No autocomplete on enter
  vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-e><CR>'
    else
      return '<CR>'
    end
  end, { expr = true, buffer = bufnr })

end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local methods = vim.lsp.protocol.Methods
    vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'popup' }
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
      buffer = bufnr,
      callback = function()
        if vim.fn.pumvisible() == 0 then
          vim.lsp.completion.get()
        end
      end,
    })

    _attach_lsp_bindings(bufnr)

  end,
})

local signs = { Error = " ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Enable LSPs
vim.lsp.enable({'pyright', 'clangd', 'bashls', 'luals'})
