require("core.editor")
--require("local.tex.continuous")

-- open explorer if no file is open...
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd("Ex")
        end
    end,
})
