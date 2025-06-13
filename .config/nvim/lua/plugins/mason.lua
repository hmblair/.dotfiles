return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {

    {
	"mason-org/mason.nvim",
        opts = {
	    ensure_installed = {
	        "clangd",
	    },
        },
    },

    {
        "neovim/nvim-lspconfig",
        config = function() 
            require("config.lspconfig")
        end
    }

    },
}
