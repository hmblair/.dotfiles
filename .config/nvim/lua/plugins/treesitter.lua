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

