return {
  'benlubas/molten-nvim',
  version = '^1.0.0',
  build = ':UpdateRemotePlugins',
  ft = { 'python', 'markdown', 'quarto' },
  init = function()
    -- Check for required Python dependencies
    local function check_python_dep(module, package)
      local ok = vim.fn.system('python3 -c "import ' .. module .. '" 2>&1')
      if vim.v.shell_error ~= 0 then
        return package
      end
      return nil
    end

    local missing = {}
    for module, package in pairs({
      pynvim = 'pynvim',
      jupyter_client = 'jupyter_client',
      nbformat = 'nbformat',
    }) do
      local m = check_python_dep(module, package)
      if m then table.insert(missing, m) end
    end

    if #missing > 0 then
      vim.notify(
        'molten-nvim: Missing Python dependencies:\n  pip3 install ' .. table.concat(missing, ' '),
        vim.log.levels.ERROR
      )
    end

    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_virt_text_output = true
  end,
  keys = {
    { '<leader>mi', ':MoltenInit python3<CR>', desc = 'Molten init kernel' },
    { '<leader>mr', ':MoltenEvaluateOperator<CR>', desc = 'Molten run operator' },
    { '<leader>ml', ':MoltenEvaluateLine<CR>', desc = 'Molten run line' },
    { '<leader>mc', ':MoltenReevaluateCell<CR>', desc = 'Molten re-run cell' },
    { '<leader>mv', ':<C-u>MoltenEvaluateVisual<CR>', mode = 'v', desc = 'Molten run selection' },
    { '<leader>md', ':MoltenDelete<CR>', desc = 'Molten delete cell' },
    { '<leader>mo', ':MoltenShowOutput<CR>', desc = 'Molten show output' },
    { '<leader>mh', ':MoltenHideOutput<CR>', desc = 'Molten hide output' },
    {
      '<leader>mb',
      function()
        -- Find fenced code block boundaries and run it
        local start_line = vim.fn.search('^```', 'bnW')
        local end_line = vim.fn.search('^```', 'nW')
        if start_line == 0 or end_line == 0 then
          vim.notify('Not inside a fenced code block', vim.log.levels.WARN)
          return
        end
        vim.fn.MoltenEvaluateRange(start_line + 1, end_line - 1)
      end,
      desc = 'Molten run code block',
    },
  },
}
