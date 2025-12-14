return{
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs", -- require(main)
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    opts = {
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "javascript", "markdown", "markdown_inline" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = true,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,
    }
}
