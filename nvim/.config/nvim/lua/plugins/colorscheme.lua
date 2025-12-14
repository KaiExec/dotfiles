return {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
        require("everforest").setup({
            transparent_background_level = 2,
            italics = true,
            disable_italic_comments = false,
        })
        vim.cmd([[colorscheme everforest]])
    end,
}
