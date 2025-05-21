---- load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

---- config
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = ""
vim.o.smartcase = true

vim.o.shortmess = vim.o.shortmess .. "I"

vim.opt.clipboard = "unnamedplus"

---- diagnostics
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
})

---- plugins
require("lazy").setup({
    spec = {
        { "junegunn/fzf" },
        { "junegunn/fzf.vim" },
        { "projekt0n/github-nvim-theme" },
        {
            {
                "nvim-lualine/lualine.nvim",
                config = function()
                    require("lualine").setup {
                        options = {
                            icons_enabled = true,
                            theme = 'auto',
                            component_separators = { left = '', right = '' },
                            section_separators = { left = '', right = '' },
                            disabled_filetypes = {
                                statusline = {},
                                winbar = {},
                            },
                            ignore_focus = {},
                            always_divide_middle = true,
                            always_show_tabline = true,
                            globalstatus = false,
                            refresh = {
                                statusline = 100,
                                tabline = 100,
                                winbar = 100,
                            }
                        },
                        sections = {
                            lualine_a = { 'mode' },
                            lualine_b = { 'branch', 'diff', 'diagnostics' },
                            lualine_c = { 'filename' },
                            lualine_x = {
                                'encoding',
                                'fileformat',
                                'filetype',
                                {
                                    require("lazy.status").updates,
                                    cond = require("lazy.status").has_updates,
                                },
                            },
                            lualine_y = { 'progress' },
                            lualine_z = { 'location' }
                        },
                        inactive_sections = {
                            lualine_a = {},
                            lualine_b = {},
                            lualine_c = { 'filename' },
                            lualine_x = { 'location' },
                            lualine_y = {},
                            lualine_z = {}
                        },
                        tabline = {},
                        winbar = {},
                        inactive_winbar = {},
                        extensions = {}
                    }
                end,
            },

        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            },
            config = function()
                require("neo-tree").setup({
                    window = { position = "right" },
                })
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end,
        },
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim",           config = true },
        { "williamboman/mason-lspconfig.nvim", config = true },
        {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup()
            end,
        },
        {
            "folke/trouble.nvim",
            config = function()
                require("trouble").setup()
            end,
        },
        {
            "gelguy/wilder.nvim",
            build = ":UpdateRemotePlugins",
            config = function()
                vim.cmd([[
                    call wilder#enable_cmdline_enter()
                    call wilder#setup({
                    \ 'modes': [':', '/', '?'],
                    \ 'next_key': '<Tab>',
                    \ 'previous_key': '<S-Tab>',
                    \ })
                ]])
            end,
        },
        {
            "neovim/nvim-lspconfig",
        },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "saadparwaiz1/cmp_luasnip",
                "L3MON4D3/LuaSnip",
            },
        },
        {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup({
                    signs = {
                        add = { hl = "GitSignsAdd", text = "+" },
                        change = { hl = "GitSignsChange", text = "~" },
                        delete = { hl = "GitSignsDelete", text = "-" },
                        topdelete = { hl = "GitSignsDelete", text = "‾" },
                        changedelete = { hl = "GitSignsChange", text = "~" },
                    },
                    numhl = false,
                    linehl = false,
                    word_diff = false,
                    current_line_blame = true,
                    watch_gitdir = {
                        interval = 1000,
                        follow_files = false,
                    },
                    update_debounce = 100,
                    diff_opts = {
                        internal = true,
                    },
                    on_attach = function(bufnr)
                        local gs = package.loaded.gitsigns
                        vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { buffer = bufnr })
                        vim.keymap.set("n", "<leader>gh", gs.reset_hunk, { buffer = bufnr })
                        vim.keymap.set("n", "<leader>gb", gs.blame_line, { buffer = bufnr })
                    end,
                })
            end
        },
    },
    install = { colorscheme = { "github_dark_default" } },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
})

---- nvim-cmp
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" },
    },
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        -- enter to confirm completion selection
        ["<CR>"] = cmp.mapping.confirm({
            select = true, -- automatically select first suggestion
        }),
    },
})

---- augroups

-- formatting
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- table of make commands per filetype
local makeprg_map = {
    python = "python3 %",
    c = "gcc % -o %:r && ./%:r",
    cpp = "g++ % -o %:r && ./%:r",
    javascript = "node %",
    arduino =
    "arduino-cli compile --fqbn arduino:avr:uno % && arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %",
    java = "javac % && java %:r",
    sh = "sh %",
}

-- function to set makeprg
local function set_makeprg()
    local cmd = makeprg_map[vim.bo.filetype]
    vim.o.makeprg = cmd or ""
end

-- `makeprg` based on the file type
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = set_makeprg,
})

-- custom command to run `make` in terminal buffer
vim.api.nvim_create_user_command("TermMake", function()
    set_makeprg()
    local height = math.floor(vim.o.lines * 0.25)
    local cmd = vim.o.makeprg
    if cmd == "" then
        print("No makeprg set for filetype: " .. vim.bo.filetype)
        return
    end
    vim.cmd("belowright " .. height .. "split | terminal " .. cmd)
    vim.cmd("startinsert")
end, { nargs = 0 })

---- colorscheme
vim.cmd("colorscheme github_dark_default")

---- lsp
require("lspconfig").lua_ls.setup({})
require("lspconfig").pyright.setup({})
require("lspconfig").ruff.setup({})
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").clangd.setup({})
require("lspconfig").arduino_language_server.setup({})

---- binds
-- neotree
vim.keymap.set("n", "\\", ":Neotree toggle<CR>", { desc = "Toggle Neotree" })

-- fuzzy
vim.keymap.set("n", "<leader>ff", ":Files<CR>", { desc = "Fuzzy find files" })
vim.keymap.set("n", "<leader>fg", ":Rg<CR>", { desc = "Fuzzy live grep" })
vim.keymap.set("n", "<leader>fb", ":Buffers<CR>", { desc = "Fuzzy buffers" })
vim.keymap.set("n", "<leader>fh", ":Helptags<CR>", { desc = "Fuzzy help tags" })

-- dev
vim.keymap.set("n", "<leader>d", "<Cmd>lua vim.lsp.buf.hover()<CR>",
    { noremap = true, silent = true, desc = "Display documentation" })
vim.keymap.set("n", "<leader>t", ":Trouble<CR>", { desc = "Toggle Trouble diagnostics" })
vim.keymap.set("n", "<leader>m", ":TermMake<CR>", { noremap = true, silent = true, desc = "Compile and run" })
vim.keymap.set("t", "<leader>q", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Quit terminal buffer" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Write and quit" })

-- windows
vim.keymap.set("n", "<leader>vs", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })
vim.keymap.set("n", "<leader>hs", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal split" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Move left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Move up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Move right" })
vim.keymap.set("n", "<C-S-h>", ":vertical resize -2<CR>",
    { noremap = true, silent = true, desc = "Resize vertical split left" })
vim.keymap.set("n", "<C-S-l>", ":vertical resize +2<CR>",
    { noremap = true, silent = true, desc = "Resize vertical split right" })
vim.keymap.set("n", "<C-S-j>", ":resize +2<CR>", { noremap = true, silent = true, desc = "Resize horizontal split down" })
vim.keymap.set("n", "<C-S-k>", ":resize -2<CR>", { noremap = true, silent = true, desc = "Resize horizontal split up" })

-- misc
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR><Esc>", { noremap = true, silent = true })
