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
      "yaml"
    },
    lazy = false,
    build = ":TSUpdate"
    }
else
  return {}
end
