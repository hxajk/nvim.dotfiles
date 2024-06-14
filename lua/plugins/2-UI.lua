-- UI Plugins

local core = require("core")
local get_icons = core.get_icon

local default = {

    -- catppuccin/nvim -> [A Soothing pastel theme for (Neo)vim]
    -- https://github.com/catppuccin/nvim

    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            background = { light = "latte", dark = "mocha" },
            transparent_background = false,
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
            },
            show_end_of_buffer = false,
            term_colors = true,
            compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
            styles = {
                comments = { "bold" },
                functions = { "bold" },
                keywords = { "bold" },
                operators = { "bold" },
                conditionals = { "bold" },
                loops = { "bold" },
                booleans = { "bold", "italic" },
                numbers = {},
                types = {},
                strings = {},
                variables = {},
                properties = {},
            },
            integrations = {
                treesitter = true,
                alpha = false,
                notify = true,
                cmp = true,
                dashboard = false,
                gitsigns = true,
                indent_blankline = { enabled = true, colored_indent_levels = true },
                markdown = true,
                mason = true,
                telescope = { enabled = true, style = "nvchad" },
            },
            color_overrides = {},
            highlight_overrides = {
                all = function(cp)
                    return {
                        CursorLineNr = { fg = cp.green },

                        WhichKeyBorder = { fg = cp.red },

                        NoiceCmdlinePopupBorder = { fg = cp.teal },
                        NoiceCmdlineIcon = { fg = cp.teal },
                        NoiceCmdlinePopupTitle = { fg = cp.teal },

                        ["@keyword.return"] = { fg = cp.pink, style = {} },
                        ["@error.c"] = { fg = cp.none, style = {} },
                        ["@error.cpp"] = { fg = cp.none, style = {} },
                    }
                end,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            require("catppuccin").load()
        end,
    },

    -- dashboard-nvim -> [A vim dashboard, greeter for neovim]
    -- https://github.com/nvimdev/dashboard-nvim

    {
        {
            "nvimdev/dashboard-nvim",
            event = "BufWinEnter",
            lazy = true,
            opts = function()
                local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
            ]]

                logo = string.rep("\n", 8) .. logo .. "\n\n"

                local opts = {
                    theme = "doom",
                    hide = {
                        statusline = false,
                        tabline = false,
                    },
                    config = {
                        header = vim.split(logo, "\n"),
                        -- stylua: ignore
                        center = {
                            { action = "Telescope find_files", desc = " Find File", icon = " ", key = "f" },
                            { action = 'lua require("core").create_file()', desc = " New File", icon = " ", key = "n" },
                            { action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
                            { action = "Telescope colorscheme", desc = " Change Background", icon = " ", key = "t" },
                            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
                            { action = 'e $MYVIMRC', desc = " Configuration", icon = " ", key = "c" },
                            { action = "qa", desc = " Quit Neovim", icon = " ", key = "q" },
                        },
                        footer = function()
                            local stats = require("lazy").stats()
                            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                            return {
                                "⚡ Neovim loaded "
                                .. stats.loaded
                                .. "/"
                                .. stats.count
                                .. " plugins in "
                                .. ms
                                .. "ms",
                            }
                        end,
                    },
                }

                for _, button in ipairs(opts.config.center) do
                    button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
                    button.key_format = "  %s"
                end

                return opts
            end,
        },
    },

    -- mini.indentscope -> [Neovim Lua plugin to visualize and operate on indent scope]
    -- https://github.com/echasnovski/mini.indentscope

    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- bufferline.nvim -> [A snazzy bufferline for Neovim]
    -- https://github.com/akinsho/bufferline.nvim

    {
        "akinsho/bufferline.nvim",
        tags = "*",
        lazy = true,
        event = { "BufReadPost", "BufAdd", "BufNewFile" },
        opts = {
            options = {
                themable = true,
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,
                -- diagnostics_indicator = function(count)
                -- 	return "(" .. count .. ")"
                -- end,

                custom_areas = {
                    right = function()
                        local result = {}
                        local seve = vim.diagnostic.severity
                        local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
                        local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
                        local info = #vim.diagnostic.get(0, { severity = seve.INFO })
                        local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

                        if error ~= 0 then
                            table.insert(
                                result,
                                { text = get_icons("DiagnosticError", 1, true) .. error, fg = "#EC5241" }
                            )
                        end

                        if warning ~= 0 then
                            table.insert(
                                result,
                                { text = get_icons("DiagnosticWarn", 1, true) .. warning, fg = "#EFB839" }
                            )
                        end

                        if hint ~= 0 then
                            table.insert(
                                result,
                                { text = get_icons("DiagnosticHint", 1, true) .. hint, fg = "#A3BA5E" }
                            )
                        end

                        if info ~= 0 then
                            table.insert(
                                result,
                                { text = get_icons("DiagnosticInfo", 1, true) .. info, fg = "#7EA9A7" }
                            )
                        end
                        return result
                    end,
                },
            },
        },
        keys = {
            {
                "<leader>b",
                "<Cmd><leader>b<CR>",
                desc = "+" .. get_icons("Buffer", 1, true) .. "Buffer",
            },
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
            { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete Other Buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
            { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
            { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
            { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
            { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
        },
        config = function(_, opts)
            vim.opt.termguicolors = true
            require("bufferline").setup(opts)
        end,
    },

    -- lualine.nvim -> [A blazing fast and easy to configure neovim statusline plugin]
    -- https://github.com/nvim-lualine/lualine.nvim

    {
        "nvim-lualine/lualine.nvim",
        lazy = true,
        event = { "BufReadPost", "BufAdd", "BufNewFile" },
        init = function()
            if vim.fn.argc(-1) > 0 then
                vim.o.statusline = " "
            else
                vim.o.laststatus = 0
            end
        end,

        opts = function()
            -- Color table for highlights
            local colors = {
                yellow   = '#ECBE7B',
                cyan     = '#008080',
                darkblue = '#081633',
                green    = '#98be65',
                orange   = '#FF8800',
                violet   = '#a9a1e1',
                magenta  = '#c678dd',
                blue     = '#51afef',
                red      = '#ec5f67',
            }

            return {
                options = {
                    theme = require("core").theme(),
                    component_separators = "",
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
                    section_separators = { left = " ", right = " " },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {

                        {
                            "filetype",
                            icon_only = false,
                            separator = " ",
                        },

                    },
                    lualine_c = {
                        { "branch" },
                        {
                            "diff",
                            symbols = {
                                added = "  ",
                                modified = "  ",
                                removed = " ",
                            },

                        },
                        { "diagnostics" },

                    },
                    lualine_x = {
                        function()
                            return require("core").lsp_progress()
                        end,
                    },
                    lualine_y = { "location" },
                    lualine_z = {
                        -- function()
                        -- 	return " " .. os.date("%R")
                        -- end,
                    },
                },
            }
        end,

        config = function(_, opts)
            require("lualine").setup(opts)
        end,
    },

    -- nvim-notify -> [A fancy, configurable, notification manager for NeoVim]
    -- https://github.com/rcarriga/nvim-notify

    {
        "rcarriga/nvim-notify",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                stages = "fade",
                timeout = 3000,
                max_height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
                max_width = function()
                    return math.floor(vim.o.columns * 0.75)
                end,
                on_open = function(win)
                    vim.api.nvim_win_set_config(win, { zindex = 100 })
                end,
            })

            vim.cmd([[
                    highlight NotifyERRORBorder guifg=#BF616A
                    highlight NotifyWARNBorder guifg=#D08770
                    highlight NotifyINFOBorder guifg=#A3BE8C
                    highlight NotifyDEBUGBorder guifg=#BFBFBF
                    highlight NotifyTRACEBorder guifg=#B48EAD

                    highlight NotifyERRORIcon guifg=#BF616A
                    highlight NotifyWARNIcon guifg=#D08770
                    highlight NotifyINFOIcon guifg=#A3BE8C
                    highlight NotifyDEBUGIcon guifg=#BFBFBF
                    highlight NotifyTRACEIcon guifg=#B48EAD

                    highlight NotifyERRORTitle  guifg=#BF616A
                    highlight NotifyWARNTitle guifg=#D08770
                    highlight NotifyINFOTitle guifg=#A3BE8C
                    highlight NotifyDEBUGTitle  guifg=#BFBFBF
                    highlight NotifyTRACETitle  guifg=#B48EAD

]])

            vim.notify = require("notify")
        end,
    },

    -- noice.nvim -> [ A plugin that completely replaces the UI for messages, cmdline and the popupmenu]
    -- https://github.com/folke/noice.nvim

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        lazy = true,
        dependencies = {
            { "MunifTanjim/nui.nvim", lazy = true },
        },
        opts = {
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
            },
        },

        keys = function()
            local noice = require("noice")
            local noice_lsp = require("noice.lsp")
            return {
                -- stylua: ignore start
                { "<S-Enter>",  function() noice.redirect(vim.fn.getcmdline()) end,                 desc = "Redirect Cmdline" },
                { "<leader>s",  "<leader>s",                                                        desc = "+" .. get_icons("Message", 1, true) .. "Notification" },
                { "<leader>sl", function() noice.cmd("last") end,                                   desc = "Noice Last Message" },
                { "<leader>sh", function() noice.cmd("history") end,                                desc = "Noice History" },
                { "<leader>sa", function() noice.cmd("all") end,                                    desc = "Noice All" },
                { "<leader>sd", function() noice.cmd("dismiss") end,                                desc = "Dismiss All" },
                { "<leader>st", function() noice.cmd("telescope") end,                              desc = "Noice Telescope" },
                { "<c-f>",      function() if not noice_lsp.scroll(4) then return "<c-f>" end end,  silent = true,                                                expr = true, desc = "Scroll Forward" },
                { "<c-b>",      function() if not noice_lsp.scroll(-4) then return "<c-b>" end end, silent = true,                                                expr = true, desc = "Scroll Backward" },
            }
            -- stylua : ignore
        end,

        config = function(_, opts)
            require("noice").setup(opts)
        end,
    },
    {
        "folke/which-key.nvim",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        init = function() end,
        opts = {

            plugins = {
                presets = {
                    operators = false,
                    motions = false,
                    text_objects = false,
                    windows = false,
                    nav = false,
                    z = true,
                    g = true,
                },
            },
            disable = { filetypes = { "TelescopePrompt" } },
            layout = {
                height = { min = 3, max = 25 },
                align = "center",
            },
            icons = {
                group = "",
            },
            window = {
                border = "double",
                position = "bottom",
                margin = { 1, 0, 1, 0 },
                padding = { 1, 1, 1, 1 },
                winblend = 0,
            },
        },
        config = function(_, opts)
            vim.o.timeout = true
            require("which-key").setup(opts)
        end,
    },
}

return default
