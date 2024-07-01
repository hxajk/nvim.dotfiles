-- Tools plugins

local icons = { tools = require("core").gets("tools"), git = require("core").gets("git") }

local default = {

    -- pleanary.nvim -> [A provider for various lua plugins]
    -- https://github.com/nvim-lua/plenary.nvim

    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },

    -- nvim-web-devicons -> [Adds file type icons to Vim plugins]
    -- https://github.com/ryanoasis/vim-devicons

    {
        "nvim-tree/nvim-web-devicons",
        enable = vim.g.icons_enabled,
        lazy = true,
    },

    -- persistence -> [Automated session for nvim]
    -- https://github.com/folke/persistence.nvim

    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        lazy = true,
        opts = {},
        keys = function()
            return {
                {
                    "<leader>s",
                    "<cmd><leader>s<cr>",
                    desc = icons.tools.Session .. "Session",
                },
                {
                    "<leader>sa",
                    [[<cmd>lua require("persistence").load()<cr>]],
                    desc = "Session: Load current",
                },
                {
                    "<leader>sb",
                    [[<cmd>lua require("persistence").load({last = true})<cr>]],
                    desc = "Session: Load last",
                },
                {
                    "<leader>sc",
                    [[<cmd>lua require("persistence").stop()<cr>]],
                    desc = "Session: Stop session",
                },
            }
        end,

        config = function(_, opts)
            require("persistence").setup(opts)
        end,
    },


    -- windwp/nvim-autopairs ->  [autopairs for neovim written in lua]
    -- autopairs for neovim written in lua

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        lazy = true,
        opts = {
            check_ts = true,
            ts_config = { java = false },
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                offset = 0,
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "PmenuSel",
                highlight_grey = "LineNr",
            },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)

            require("cmp").event:on(
                "confirm_done",
                require("nvim-autopairs.completion.cmp").on_confirm_done({ tex = false })
            )
        end,
    },

    {
        'CRAG666/code_runner.nvim',

        keys = {
            { "<leader>r", "<Cmd>RunCode<CR>",      desc = "Code: Run" },
        },

        opts =  {

        },

        config = function (_,opts)
            require("code_runner").setup(opts)
        end
    },

    -- lewis6991/gitsigns.nvim -> [Git integration for buffers]
    -- https://github.com/lewis6991/gitsigns.nvim

    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        enabled = vim.fn.executable("git") == 1,

        opts = {

            watch_gitdir = { interval = 1000, follow_files = true },
            current_line_blame = true,
            current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            word_diff = false,
            diff_opts = { internal = true },
            on_attach = function(_)
                local gs = package.loaded.gitsigns

                -- stylua: ignore start
                vim.keymap.set('n', '<leader>g', '<leader>g', { desc = icons.git.Git .. "Git" })
                vim.keymap.set('n', ']g', function() gs.nav_hunk("last") end, { desc = 'Git: Last Hunk' })
                vim.keymap.set('n', '[g', function() gs.nav_hunk("first") end, { desc = 'Git : First Hunk' })
                vim.keymap.set({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', { desc = 'Git: Stage Hunk' })
                vim.keymap.set({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>', { desc = 'Git: Reset Hunk' })
                vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { desc = 'Git: Reset Buffer' })
                vim.keymap.set('n', '<leader>gp', gs.preview_hunk_inline, { desc = 'Git: Preview Hunk Inline' })
                vim.keymap.set('n', '<leader>gb', function() gs.blame_line({ full = true }) end, { desc = 'Git: Blame Line' })
                vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = 'Git: Diff This' })
            end,
        },
    },


    -- toggleterm.nvim -> [Manager for multiple terminal windows]
    -- https://github.com//akinsho/toggleterm.nvim

    {
        "akinsho/toggleterm.nvim",
        lazy = true,
        cmd = {
            "ToggleTerm",
            "ToggleTermSetName",
            "ToggleTermToggleAll",
            "ToggleTermSendVisualLines",
            "ToggleTermSendCurrentLine",
            "ToggleTermSendVisualSelection",
        },
        opts = {
            on_open = function(_)
                -- Prevent infinite calls from freezing neovim.
                -- Only set these options specific to this terminal buffer.
                vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
                vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
            end,
            highlights = {
                Normal = { link = "Normal" },
                NormalNC = { link = "NormalNC" },
                NormalFloat = { link = "NormalFloat" },
                FloatBorder = { link = "FloatBorder" },
                StatusLine = { link = "StatusLine" },
                StatusLineNC = { link = "StatusLineNC" },
                WinBar = { link = "WinBar" },
                WinBarNC = { link = "WinBarNC" },
            },
            open_mapping = false,
            hide_numbers = true,
            shade_filetypes = {},
            float_opts = { border = "rounded" },
            shade_terminals = false,
            shading_factor = 2,
            start_in_insert = true,
            persist_mode = false,
            insert_mappings = true,
            persist_size = true,
            close_on_exit = true,
            shell = vim.o.shell,
        },

        keys = {
            {
                "<leader>t",
                "<Cmd><leader>t<CR>",
                desc = icons.tools.Terminal .. "Terminal",
            },
            { "<leader>tt", "<Cmd>ToggleTerm direction=float<CR>",      desc = "Terminal: Toggle float" },
            { "<leader>th", "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal: Toggle horizontal" },
            { "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>",   desc = "Terminal: Toggle vertical" },
        },

        config = function(_, opts)
            require("toggleterm").setup(opts)
        end,
    },

    {
        "gelguy/wilder.nvim",
        lazy = true,
        event = "CmdlineEnter",

        dependencies = { "romgrk/fzy-lua-native" },

        config = function()
            local wilder = require("wilder")
            local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
                border = "rounded",
                highlights = {
                    default = "Pmenu",
                    border = "PmenuBorder",
                    accent = wilder.make_hl("WilderAccent", "CmpItemAbbr", "CmpItemAbbrMatch"),
                },
                empty_message = wilder.popupmenu_empty_message_with_spinner(),
                highlighter = wilder.lua_fzy_highlighter(),
                left = {
                    " ",
                    wilder.popupmenu_devicons(),
                },
                right = {
                    " ",
                    wilder.popupmenu_scrollbar(),
                },
            }))
            wilder.set_option(
                "renderer",
                wilder.renderer_mux({
                    [":"] = popupmenu_renderer,
                })
            )
            wilder.setup({ modes = { ":", "/", "?" } })
        end,
    },

    -- telescope.nvim -> [A fuzzy finder]
    -- https://github.com//nvim-telescope/telescope.nvim

    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        cmd = { "Telescope", "Mason" },
        dependencies = {
            {
                "nvim-telescope/telescope-ui-select.nvim",
            },
        },
        opts = {
            pickers = {
                colorscheme = {
                    enable_preview = true,
                },
                find_files = {
                    find_command = { "fd", "--type=file", "--follow", "--exclude=.git" },
                },
            },
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob=!.git/",
                },

                prompt_prefix = icons.tools.TelescopePrompt,
                selection_caret = icons.tools.Selected,
                initial_mode = "insert",
                sorting_strategy = "ascending",
                -- layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                path_display = { "truncate" },
                color_devicons = true,
                results_title = false,
                file_ignore_patterns = {
                    ".cache/**",
                    "build/**",
                    "bin/*",
                    ".git/*",
                    "node_modules",
                },
            },

            extensions = {},
        },

        keys = {
            { "<leader>f", "<leader>f", desc = icons.tools.Telescope .. "Telescope" },
        },

        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("ui-select")

            vim.keymap.set("n", "<leader>fa", function()
                require("telescope.builtin").find_files({
                    prompt_title = "Config Files",
                    cwd = vim.fn.stdpath("config"),
                    follow = true,
                })
            end, { desc = "Find nvim config files" })

            vim.keymap.set("n", "<leader>fb", [[<cmd> lua require("telescope.builtin").buffers() <cr> ]],
                { desc = "Find: Buffers" })

            vim.keymap.set("n", "<leader>fh", [[
               <cmd> lua require("telescope.builtin").help_tags() <cr>
            ]],
                { desc = "Find: help" })

            vim.keymap.set("n", "<leader>f/", [[
              <cmd> lua  require("telescope.builtin").current_buffer_fuzzy_find() <cr>
           ]], { desc = "Find: word in current buffer" })

            vim.keymap.set("n", "<leader>fo", [[
               <cmd> lua require("telescope.builtin").oldfiles() <cr>
           ]], { desc = "Find: recent" })

            vim.keymap.set("n", "<leader>ff", [[
               <cmd> lua require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) <cr>
           ]], { desc = "Find: files" })

            vim.keymap.set("n", "<leader>ft", [[
               <cmd> lua require("telescope.builtin").colorscheme({ enable_preview = true }) <cr>
           ]], { desc = "Find: themes" })

            if vim.fn.executable("rg") == 1 then
                vim.keymap.set("n", "<leader>fw", [[
                <cmd> lua require("telescope.builtin").live_grep() <cr>
           ]], { desc = "Find: Words" })
            end
        end,
    },
}

return default
