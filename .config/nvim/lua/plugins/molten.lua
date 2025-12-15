return {
  'benlubas/molten-nvim',
  version = '^1.0.0',
  build = ':UpdateRemotePlugins',
  ft = { 'python', 'markdown', 'quarto' },
  init = function()
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_virt_text_output = true
  end,
  config = function()
  -- Wait for buffer to be fully loaded and check if it's valid
  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(0) then
      return
    end

    local filename = vim.api.nvim_buf_get_name(0)
    local ft = vim.bo.filetype

    local is_notebook = filename:match('%.ipynb$')

    if not is_notebook then
      return
    end

    -- Check for required Python dependencies
    local function check_python_dep(module, package)
      local ok, result = pcall(function()
        return vim.fn.system('python3 -c "import ' .. module .. '" 2>&1')
      end)
      if not ok or vim.v.shell_error ~= 0 then
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
        vim.log.levels.WARN
      )
    end
  end)
end,
  keys = {
    -- ... existing keys remain the same
  },
}
