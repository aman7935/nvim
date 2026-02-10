return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        opts = {
            ensure_installed = {
                "lua",
                "vim",
                "bash",
                "javascript",
                "typescript",
                "tsx",
                "python",
                "kotlin",
                "java",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enable = true },
        },
    },
}
