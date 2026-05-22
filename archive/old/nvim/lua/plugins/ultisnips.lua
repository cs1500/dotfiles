return {
    {
        -- UltiSnips plugin for snippets
        {
            "SirVer/ultisnips",
            dependencies = {
                "honza/vim-snippets",  -- Popular snippets library
            },
            config = function()
                -- Configuration options for UltiSnips
                vim.g.UltiSnipsExpandTrigger = '<Tab>'   -- Use <Tab> to expand snippets
                vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
                vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
                vim.g.UltiSnipsEditSplit = "vertical"  -- Open snippet in vertical split for editing
            end,
        },
    }
}
