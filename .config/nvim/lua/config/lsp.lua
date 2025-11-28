-- Disable logging
vim.lsp.log.set_level(vim.log.levels.OFF)

-- Diagnostic configuration
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '󰌶',
      [vim.diagnostic.severity.INFO] = '●',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = {
    prefix = '✘',
    severity = vim.diagnostic.severity.ERROR,
  },
  float = {
    border = 'rounded',
  },
})

-- Global diagnostic keymap (works without LSP attached)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror' })

-- LSP buffer-local keymaps
local function attach_lsp_keymaps(bufnr)
  local opts = function(desc)
    return { buffer = bufnr, desc = desc }
  end

  -- Diagnostic navigation
  vim.keymap.set('n', 'je', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
  end, opts('[J]ump next [E]rror'))
  vim.keymap.set('n', 'Je', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
  end, opts('[J]ump prev [E]rror'))
  vim.keymap.set('n', 'jw', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
  end, opts('[J]ump next [W]arning'))
  vim.keymap.set('n', 'Jw', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
  end, opts('[J]ump prev [W]arning'))

  -- LSP navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('[G]oto [D]efinition'))
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('[G]oto [D]eclaration'))
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts('[G]oto [T]ype definition'))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts('[G]oto [I]mplementation'))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('[G]oto [R]eferences'))

  -- LSP actions
  vim.keymap.set('n', 'hd', vim.lsp.buf.hover, opts('[H]over [D]ocumentation'))
  vim.keymap.set('n', 're', vim.lsp.buf.rename, opts('[R]ename symbol'))

  -- Dismiss autocomplete on enter
  vim.keymap.set('i', '<CR>', function()
    return vim.fn.pumvisible() == 1 and '<C-e><CR>' or '<CR>'
  end, { expr = true, buffer = bufnr, desc = 'Smart Enter' })
end

-- LSP attach handler
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspConfig', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Enable completion
    vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'popup' }
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

    -- Trigger completion on text change
    vim.api.nvim_create_autocmd('TextChangedI', {
      buffer = bufnr,
      callback = function()
        if vim.fn.pumvisible() == 0 then
          vim.lsp.completion.get()
        end
      end,
    })

    attach_lsp_keymaps(bufnr)
  end,
})

-- Enable LSP servers
vim.lsp.enable({ 'pyright', 'clangd', 'bashls', 'luals' })
