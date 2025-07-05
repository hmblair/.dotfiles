if vim.fn.has("nvim-0.11") == 1 then
    return {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {

        {
            "mason-org/mason.nvim",
            opts = {
                ensure_installed = {
                    "clangd",
                    "pyright",
                },
            },
        },

        {
            "neovim/nvim-lspconfig",
            config = function()
                require("config.lspconfig")
            end,
        }

        },
    }
else
    return {}
end
