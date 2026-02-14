local M = {}

-- initialise state variables
local state = {
    timer = nil,
    running = false,
    pending = false,
    enabled = false,
}

local function project_root(bufnr)
    -- Determine project root from the buffer path.
    -- Walks upward until a directory containing main.tex is found;
    -- falls back to the current working directory.
    -- 0 means current neovim buffer!
    bufnr = bufnr or 0
    return vim.fs.root(
        bufnr,
        {"main.tex",}
    ) or vim.fn.getcwd()
end

local function main_tex(root)
    local p = root .. "/main.tex"
    if vim.uv.fs_stat(p) then
        return p
    end
    return nil
end

local function has(cmd)
    return vim.fn.executable(cmd) == 1
end

local function compile(root)
    if state.running then
        state.pending = true
        return
    end

    local m = main_tex(root)
    if not m then
        vim.notify("No main.tex found under root: " .. root, vim.log.levels.WARN)
        return
    end

    state.running = true
    state.pending = false

    local cmd
    if has("latexmk") then
        cmd = {
            "latexmk",
            "-pdf",
            "-interaction=nonstopmode",
            "-synctex=1",
            "-halt-on-error",
            "-outdir=build",
            "main.tex",
        }
    else
        cmd = {
            "pdflatex",
            "-interaction=nonstopmode",
            "-synctex=1",
            "-halt-on-error",
            "-output-directory=build",
            "main.tex",
        }
    end

    vim.fn.setqflist({}, "r")

    vim.system(cmd, { cwd = root, text = true }, function(res)
        vim.schedule(function()
            state.running = false

            local out = (res.stdout or "") .. "\n" .. (res.stderr or "")
            if res.code == 0 then
                vim.notify("LaTeX OK (" .. root .. ")", vim.log.levels.INFO)
            else
                local items = {}
                for line in out:gmatch("[^\r\n]+") do
                    items[#items + 1] = { text = line }
                end
                vim.fn.setqflist(items, "r", { title = "LaTeX build output" })
                vim.cmd("copen")
                vim.notify("LaTeX FAILED (" .. root .. ")", vim.log.levels.ERROR)
            end

            if state.enabled and state.pending then
                compile(root)
            end
        end)
    end)
end

local function schedule_compile(bufnr)
    if not state.enabled then
        return
    end

    local root = project_root(bufnr)

    if not state.timer then
        state.timer = vim.uv.new_timer()
    end

    state.timer:stop()
    state.timer:start(250, 0, function()
        vim.schedule(function()
            compile(root)
        end)
    end)
end

function M.start()
    state.enabled = true
    vim.notify("LaTeX continuous compile: ON", vim.log.levels.INFO)
    schedule_compile(0)
end

function M.stop()
    state.enabled = false
    state.pending = false
    if state.timer then
        state.timer:stop()
        state.timer:close()
        state.timer = nil
    end
    vim.notify("LaTeX continuous compile: OFF", vim.log.levels.INFO)
end

function M.toggle()
    if state.enabled then
        M.stop()
    else
        M.start()
    end
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.tex" },
    callback = function(args)
        schedule_compile(args.buf)
    end,
})

vim.api.nvim_create_user_command("LatexStart", M.start, {})
vim.api.nvim_create_user_command("LatexStop", M.stop, {})
vim.api.nvim_create_user_command("LatexToggle", M.toggle, {})

return M
