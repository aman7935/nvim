return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = {
            "lua_ls",
            "basedpyright",
            "vtsls",
        },
        automatic_installation = true,
        automatic_enable = false,
    },
}

