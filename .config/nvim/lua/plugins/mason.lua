if vim.fn.has("nvim-0.11") == 1 then
  return {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "pylsp",
        "bash-language-server",
        "lua_ls",
      },
    },
  }
else
  return {}
end
