return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  cond = vim.fn.has('nvim-0.10') == 1,
  config = function()
    local parsers = {
      'bash',
      'c',
      'cpp',
      'cmake',
      'javascript',
      'json',
      'json5',
      'lua',
      'markdown',
      'python',
      'yaml',
    }
    -- latex requires tree-sitter CLI to generate
    if vim.fn.executable('tree-sitter') == 1 then
      table.insert(parsers, 'latex')
    end
    require('nvim-treesitter.configs').setup({
      ensure_installed = parsers,
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
