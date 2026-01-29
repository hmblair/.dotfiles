-- Disable logging
vim.lsp.log.set_level(vim.log.levels.OFF)

-- Diagnostic configuration
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '',
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
local function diagnostic_float_with_action()
  local orig_win = vim.api.nvim_get_current_win()
  local orig_buf = vim.api.nvim_win_get_buf(orig_win)
  local line = vim.api.nvim_win_get_cursor(orig_win)[1] - 1
  local diagnostics = vim.diagnostic.get(orig_buf, { lnum = line })

  if #diagnostics == 0 then return end

  -- Build float content with numbered diagnostics
  local lines = {}
  local diag_map = {} -- maps float line number to diagnostic index
  for i, diag in ipairs(diagnostics) do
    local msg = diag.message:gsub('\n', ' ')
    table.insert(lines, string.format('%d. %s', i, msg))
    diag_map[#lines] = i
  end

  -- Create float buffer
  local float_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
  vim.bo[float_buf].modifiable = false

  -- Calculate float size
  local width = math.min(60, math.max(unpack(vim.tbl_map(function(l) return #l end, lines))))
  local height = #lines

  -- Open float window
  local winid = vim.api.nvim_open_win(float_buf, true, {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })

  -- Keymaps
  vim.keymap.set('n', '<CR>', function()
    local cursor_line = vim.api.nvim_win_get_cursor(winid)[1]
    local diag_idx = diag_map[cursor_line] or 1
    local diag = diagnostics[diag_idx]
    vim.api.nvim_win_close(winid, true)
    vim.api.nvim_set_current_win(orig_win)
    vim.api.nvim_win_set_cursor(orig_win, { diag.lnum + 1, diag.col })
    vim.lsp.buf.code_action()
  end, { buffer = float_buf, desc = 'Code action' })

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(winid, true)
  end, { buffer = float_buf, desc = 'Close' })

  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(winid, true)
  end, { buffer = float_buf, desc = 'Close' })
end
vim.keymap.set('n', '<leader>e', diagnostic_float_with_action, { desc = 'Show diagnostic [E]rror' })

-- LSP buffer-local keymaps
local function attach_lsp_keymaps(bufnr)
  local opts = function(desc)
    return { buffer = bufnr, desc = desc }
  end

  -- Diagnostic navigation
  local jumps = {
    { 'je', 1, 'ERROR', '[J]ump next [E]rror' },
    { 'Je', -1, 'ERROR', '[J]ump prev [E]rror' },
    { 'jw', 1, 'WARN', '[J]ump next [W]arning' },
    { 'Jw', -1, 'WARN', '[J]ump prev [W]arning' },
  }
  for _, j in ipairs(jumps) do
    vim.keymap.set('n', j[1], function()
      vim.diagnostic.jump({ count = j[2], severity = vim.diagnostic.severity[j[3]], float = true })
    end, opts(j[4]))
  end

  -- LSP navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('[G]oto [D]efinition'))
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('[G]oto [D]eclaration'))
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts('[G]oto [T]ype definition'))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts('[G]oto [I]mplementation'))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('[G]oto [R]eferences'))

  -- LSP actions
  vim.keymap.set('n', 'hd', vim.lsp.buf.hover, opts('[H]over [D]ocumentation'))
  vim.keymap.set('n', 're', vim.lsp.buf.rename, opts('[R]ename symbol'))
  vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, opts('[C]ode [A]ction'))

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
vim.lsp.enable({ 'pyright', 'clangd', 'bashls', 'luals', 'texlab', 'harper_ls' })
