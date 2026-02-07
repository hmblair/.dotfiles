-- Servers that require npm to install.
local npm_servers = {
  'bash-language-server',
  'pyright',
}

local ensure_installed = {
  'harper-ls',
  'lua-language-server',
  'texlab',
  -- clangd: install via Mason on macOS, or 'apt install clangd' on Linux
}

if vim.fn.executable('npm') == 1 then
  vim.list_extend(ensure_installed, npm_servers)
else
  vim.notify(
    'npm not found: ' .. table.concat(npm_servers, ', ') .. ' will not be installed',
    vim.log.levels.WARN
  )
end

return {
  {
    'mason-org/mason.nvim',
    cond = vim.fn.has('nvim-0.11') == 1,
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cond = vim.fn.has('nvim-0.11') == 1,
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = ensure_installed,
    },
  },
}
