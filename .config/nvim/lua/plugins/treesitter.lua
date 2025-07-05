if vim.fn.has("nvim-0.10") == 1 then
  return {
    "nvim-treesitter/nvim-treesitter", 
    branch = 'master', 
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "json",
      "latex",
      "lua",
      "markdown",
      "python",
      "yaml",
      "javascript",
      "cmake",
      "json5",
    },
    lazy = false,
    build = ":TSUpdate",
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    }
else
  return {}
end
