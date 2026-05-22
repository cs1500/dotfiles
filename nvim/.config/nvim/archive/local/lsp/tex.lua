vim.lsp.config.digestif = {
    cmd = {"digestif"},                 -- start lsp
    filetypes = {                       -- files to attach lsp
        "tex", "plaintex", "bibtex"
    },
}
vim.lsp.enable("digestif")
--print("tex.lua loaded")