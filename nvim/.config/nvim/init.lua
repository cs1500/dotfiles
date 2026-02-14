require("core.editor")
require("local.tex.continuous")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd("Ex")
        end
    end,
})