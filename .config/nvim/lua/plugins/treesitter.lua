if vim.fn.has("nvim-0.10") == 1 then
  return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    config = function ()
      require("nvim-treesitter.configs").setup({
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
        sync_install = false,
        auto_install = true,
        build = ":TSUpdate",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  }
else
  return {}
end
