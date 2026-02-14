-- enable line numbers
vim.opt.number = true

-- 80 character ruler
vim.opt.colorcolumn = "80"

-- highlight current line
vim.opt.cursorline = true

-- indentation settings
vim.opt.expandtab = true    -- tabs as spaces
vim.opt.shiftwidth = 4      -- >> and << shift by 4 spaces

vim.opt.statusline = "%n %f %m%r %= buf:%n"

vim.opt.clipboard = "unnamedplus" -- for clipboard copy to work
