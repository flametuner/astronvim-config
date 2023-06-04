return {
  colorscheme = "catppuccin",
  lsp = {
    formatting = {
      format_on_save = false,
    },
    servers = {
      "lua_ls",
      "terraformls",
      "gopls",
      "solidity_ls_nomicfoundation"
    },
    config = {
      lua_ls = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    },
    setup_handlers = {
      -- add custom handler
      rust_analyzer = function(_, opts)
        local rt = require "rust-tools"

        local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/'
        local codelldb_path = extension_path .. 'adapter/codelldb'
        local liblldb_path = extension_path .. 'lldb/lib/liblldb.so' -- MacOS: This may be .dylib

        local dap = {
          adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path)
        }

        rt.setup {
          hover_actions = {
            auto_focues = true,
          },
          dap = dap,
          server = opts,
        }
        vim.keymap.set("n", "<Leader>rg", rt.code_action_group.code_action_group,
          { buffer = bufnr, desc = "Open Action Group" })
        vim.keymap.set("n", "<Leader>ra", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Open Hover Actions" })
      end,
      tsserver = function(_, opts) require("typescript").setup { server = opts } end,
    },
  },
  -- add new user interface icon
  icons = {
    VimIcon = "",
    ScrollText = "",
    GitBranch = "",
    GitAdd = "",
    GitChange = "",
    GitDelete = "",
  },
  -- modify variables used by heirline but not defined in the setup call directly
  heirline = {
    -- define the separators between each section
    separators = {
      left = { "", " " }, -- separator for the left side of the statusline
      right = { " ", "" }, -- separator for the right side of the statusline
      tab = { "", "" },
    },
    -- add new colors that can be used by heirline
    colors = function(hl)
      local get_hlgroup = require("astronvim.utils").get_hlgroup
      -- use helper function to get highlight group properties
      local comment_fg = get_hlgroup("Comment").fg
      hl.git_branch_fg = comment_fg
      hl.git_added = comment_fg
      hl.git_changed = comment_fg
      hl.git_removed = comment_fg
      hl.blank_bg = get_hlgroup("Folded").fg
      hl.file_info_bg = get_hlgroup("Visual").bg
      hl.nav_icon_bg = get_hlgroup("String").fg
      hl.nav_fg = hl.nav_icon_bg
      hl.folder_icon_bg = get_hlgroup("Error").fg
      return hl
    end,
    attributes = {
      mode = { bold = true },
    },
    icon_highlights = {
      file_icon = {
        statusline = false,
      },
    },
  },
  plugins = {
    {
      "rcarriga/nvim-notify",
      opts = {
        top_down = false
      }
    },
    {
      "akinsho/toggleterm.nvim",
      opts = {
        open_mapping = [[<C-t>]],
      }
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        window = {
          position = "right",
        },
      },
    },
    "jose-elias-alvarez/typescript.nvim", -- add lsp plugin
    "simrat39/rust-tools.nvim",           -- add lsp plugin
    "ray-x/go.nvim",
    {
      "ggandor/leap.nvim",
      event = "UIEnter",
      config = function()
        require("leap").add_default_mappings()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "rust_analyzer", "tsserver", "terraformls", "gopls", "solidity_ls_nomicfoundation" },
      },
    },
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      event = "UIEnter",
      dependencies = {
        "zbirenbaum/copilot-cmp"
      },
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    },
    {
      "zbirenbaum/copilot-cmp",
      config = function(_, opts)
        local copilot_cmp = require "copilot_cmp"
        local opts = {
          formatters = {
            label = require("copilot_cmp.format").format_label_text,
            insert_text = require("copilot_cmp.format").format_insert_text,
            preview = require("copilot_cmp.format").deindent,
          },
        }
        copilot_cmp.setup(opts)
      end
    },
    {
      "hrsh7th/nvim-cmp",
      commit = "935b4069ce73b60ba9075bf05ee6ab50ed3af1a9",
      dependencies = { "zbirenbaum/copilot.lua" },
      opts = function(_, opts)
        local cmp, copilot = require "cmp", require "copilot.suggestion"
        local function has_words_before()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end
        if not opts.mapping then opts.mapping = {} end
        -- opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        --   if copilot.is_visible() then
        --     copilot.accept()
        --   elseif cmp.visible() then
        --     cmp.select_next_item()
        --   elseif luasnip.expand_or_jumpable() then
        --     luasnip.expand_or_jump()
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" })
        opts.mapping["<Tab>"] = vim.schedule_wrap(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end)
        -- opts.mapping["<cr>"] = cmp.mapping.confirm {
        --   behavior = cmp.confirmbehavior.replace,
        --   select = true,
        -- }
        opts.mapping["<C-e>"] = cmp.mapping {
          i = function(fallback)
            if copilot.is_visible() then
              copilot.dismiss()
            elseif not cmp.abort() then
              fallback()
            end
          end,
          c = function(fallback)
            if copilot.is_visible() then
              copilot.dismiss()
            elseif not cmp.close() then
              fallback()
            end
          end,
        }
        opts.sources = {
          { name = "nvim_lsp", priority = 1000, group_index = 2 },
          { name = "copilot",  priority = 950,  group_index = 2 },
          { name = "luasnip",  priority = 750,  group_index = 2 },
          { name = "buffer",   priority = 500,  group_index = 2 },
          { name = "path",     priority = 250,  group_index = 2 },
        }

        local lspkind_comparator = function(conf)
          local lsp_types = require('cmp.types').lsp
          return function(entry1, entry2)
            if entry1.source.name ~= 'nvim_lsp' then
              if entry2.source.name == 'nvim_lsp' then
                return false
              else
                return nil
              end
            end
            local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
            local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

            local priority1 = conf.kind_priority[kind1] or 0
            local priority2 = conf.kind_priority[kind2] or 0
            if priority1 == priority2 then
              return nil
            end
            return priority2 < priority1
          end
        end
        opts.sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,
            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            lspkind_comparator({
              kind_priority = {
                Copilot = 13,
                Field = 12,
                Property = 11,
                Constant = 10,
                Enum = 10,
                EnumMember = 10,
                Event = 10,
                Function = 10,
                Method = 10,
                Operator = 10,
                Reference = 10,
                Struct = 10,
                Variable = 12,
                File = 8,
                Folder = 8,
                Class = 5,
                Color = 5,
                Module = 5,
                Keyword = 2,
                Constructor = 1,
                Interface = 1,
                Snippet = 0,
                Text = 1,
                TypeParameter = 1,
                Unit = 1,
                Value = 1,
              },
            }),
            cmp.config.compare.kind,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        }
        local lspkind = require("lspkind")
        lspkind.symbol_map["Copilot"] = ""
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

        return opts
      end,
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require("astronvim.utils.status")
        opts.statusline = {
          -- default highlight for the entire statusline
          hl = { fg = "fg", bg = "bg" },
          -- each element following is a component in astronvim.utils.status module

          -- add the vim mode component
          status.component.mode {
            -- enable mode text with padding as well as an icon before it
            mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
            -- surround the component with a separators
            surround = {
              -- it's a left element, so use the left separator
              separator = "left",
              -- set the color of the surrounding based on the current mode using astronvim.utils.status module
              color = function() return { main = status.hl.mode_bg(), right = "blank_bg" } end,
            },
          },
          -- we want an empty space here so we can use the component builder to make a new section with just an empty string
          status.component.builder {
            { provider = "" },
            -- define the surrounding separator and colors to be used inside of the component
            -- and the color to the right of the separated out section
            surround = { separator = "left", color = { main = "blank_bg", right = "file_info_bg" } },
          },
          -- add a section for the currently opened file information
          status.component.file_info {
            -- enable the file_icon and disable the highlighting based on filetype
            file_icon = { padding = { left = 0 } },
            filename = { fallback = "Empty" },
            -- add padding
            padding = { right = 1 },
            -- define the section separator
            surround = { separator = "left", condition = false },
          },
          -- add a component for the current git branch if it exists and use no separator for the sections
          status.component.git_branch { surround = { separator = "none" } },
          -- add a component for the current git diff if it exists and use no separator for the sections
          status.component.git_diff { padding = { left = 1 }, surround = { separator = "none" } },
          -- fill the rest of the statusline
          -- the elements after this will appear in the middle of the statusline
          status.component.fill(),
          -- add a component to display if the LSP is loading, disable showing running client names, and use no separator
          status.component.lsp { lsp_client_names = false, surround = { separator = "none", color = "bg" } },
          -- fill the rest of the statusline
          -- the elements after this will appear on the right of the statusline
          status.component.fill(),
          -- add a component for the current diagnostics if it exists and use the right separator for the section
          status.component.diagnostics { surround = { separator = "right" } },
          -- add a component to display LSP clients, disable showing LSP progress, and use the right separator
          status.component.lsp { lsp_progress = false, surround = { separator = "right" } },
          -- NvChad has some nice icons to go along with information, so we can create a parent component to do this
          -- all of the children of this table will be treated together as a single component
          {
            -- define a simple component where the provider is just a folder icon
            status.component.builder {
              -- astronvim.get_icon gets the user interface icon for a closed folder with a space after it
              { provider = require("astronvim.utils").get_icon "FolderClosed" },
              -- add padding after icon
              padding = { right = 1 },
              -- set the foreground color to be used for the icon
              hl = { fg = "bg" },
              -- use the right separator and define the background color
              surround = { separator = "right", color = "folder_icon_bg" },
            },
            -- add a file information component and only show the current working directory name
            status.component.file_info {
              -- we only want filename to be used and we can change the fname
              -- function to get the current working directory name
              filename = { fname = function(nr) return vim.fn.getcwd(nr) end, padding = { left = 1 } },
              -- disable all other elements of the file_info component
              file_icon = false,
              file_modified = false,
              file_read_only = false,
              -- use no separator for this part but define a background color
              surround = { separator = "none", color = "file_info_bg", condition = false },
            },
          },
          -- the final component of the NvChad statusline is the navigation section
          -- this is very similar to the previous current working directory section with the icon
          { -- make nav section with icon border
            -- define a custom component with just a file icon
            status.component.builder {
              { provider = require("astronvim.utils").get_icon "ScrollText" },
              -- add padding after icon
              padding = { right = 1 },
              -- set the icon foreground
              hl = { fg = "bg" },
              -- use the right separator and define the background color
              -- as well as the color to the left of the separator
              surround = { separator = "right", color = { main = "nav_icon_bg", left = "file_info_bg" } },
            },
            -- add a navigation component and just display the percentage of progress in the file
            status.component.nav {
              -- add some padding for the percentage provider
              percentage = { padding = { right = 1 } },
              -- disable all other providers
              ruler = false,
              scrollbar = false,
              -- use no separator and define the background color
              surround = { separator = "none", color = "file_info_bg" },
            },
          },
        }

        -- return the final options table
        return opts
      end,
    },
  },
}
