-- ============================================================================
-- AI Integration Configuration for AstroNvim
-- ============================================================================
-- This file configures multiple AI assistants:
-- - GitHub Copilot
-- - Codeium (free alternative)
-- - ChatGPT integration
-- - Avante (Cursor-like AI)

return {
  -- ============================================================================
  -- GitHub Copilot
  -- ============================================================================
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = false, -- We'll handle this with Tab
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom",
          ratio = 0.4,
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node",
      server_opts_overrides = {},
    },
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = false,
      window = {
        layout = "vertical",
        width = 0.5,
        height = 0.5,
      },
    },
  },

  -- ============================================================================
  -- Codeium (Free Alternative to Copilot)
  -- ============================================================================
  {
    "Exafunction/codeium.nvim",
    enabled = false, -- Enable this and disable Copilot if you prefer Codeium
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    event = "InsertEnter",
    config = function()
      require("codeium").setup({
        enable_chat = true,
        virtual_text = {
          enabled = true,
          manual = false,
          filetypes = {},
          default_filetype_enabled = true,
          idle_delay = 75,
          key_bindings = {
            accept = false, -- We'll handle this with Tab
            accept_word = "<M-w>",
            accept_line = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      })
    end,
  },

  -- ============================================================================
  -- ChatGPT Integration
  -- ============================================================================
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "echo $OPENAI_API_KEY",
        yank_register = "+",
        edit_with_instructions = {
          diff = false,
          keymaps = {
            close = "<C-c>",
            accept = "<C-y>",
            toggle_diff = "<C-d>",
            toggle_settings = "<C-o>",
            toggle_help = "<C-h>",
            cycle_windows = "<Tab>",
            use_output_as_input = "<C-i>",
          },
        },
        chat = {
          welcome_message = "Welcome to ChatGPT! Type your question below.",
          loading_text = "Loading, please wait ...",
          question_sign = "🤔",
          answer_sign = "🤖",
          border_left_sign = "▌",
          border_right_sign = "▐",
          max_line_length = 120,
          sessions_window = {
            active_sign = " 󰄵 ",
            inactive_sign = " 󰄱 ",
            current_line_sign = "",
            border = {
              style = "rounded",
              text = {
                top = " Sessions ",
              },
            },
            win_options = {
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          },
          keymaps = {
            close = "<C-c>",
            yank_last = "<C-y>",
            yank_last_code = "<C-k>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
            cycle_modes = "<C-f>",
            next_message = "<C-j>",
            prev_message = "<C-k>",
            select_session = "<Space>",
            rename_session = "r",
            delete_session = "d",
            draft_message = "<C-r>",
            edit_message = "e",
            delete_message = "d",
            toggle_settings = "<C-o>",
            toggle_sessions = "<C-p>",
            toggle_help = "<C-h>",
            toggle_message_role = "<C-r>",
            toggle_system_role_open = "<C-s>",
            stop_generating = "<C-x>",
          },
        },
        popup_layout = {
          default = "center",
          center = {
            width = "80%",
            height = "80%",
          },
          right = {
            width = "30%",
            width_settings_open = "50%",
          },
        },
        popup_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " ChatGPT ",
            },
          },
          win_options = {
            wrap = true,
            linebreak = true,
            foldcolumn = "1",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          buf_options = {
            filetype = "markdown",
          },
        },
        system_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " SYSTEM ",
            },
          },
          win_options = {
            wrap = true,
            linebreak = true,
            foldcolumn = "2",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        popup_input = {
          prompt = "  ",
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top_align = "center",
              top = " Prompt ",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          submit = "<C-Enter>",
          submit_n = "<Enter>",
          max_visible_lines = 20,
        },
        settings_window = {
          setting_sign = "  ",
          border = {
            style = "rounded",
            text = {
              top = " Settings ",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        help_window = {
          setting_sign = "  ",
          border = {
            style = "rounded",
            text = {
              top = " Help ",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        openai_params = {
          model = "gpt-4",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4096,
          temperature = 0.7,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "gpt-4",
          frequency_penalty = 0,
          presence_penalty = 0,
          temperature = 0.7,
          top_p = 1,
          n = 1,
        },
        use_openai_functions_for_edits = false,
        actions_paths = {},
        show_quickfixes_cmd = "Trouble quickfix",
        predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
        highlights = {
          help_key = "@symbol",
          help_description = "@comment",
        },
      })
    end,
  },

  -- ============================================================================
  -- Avante (Cursor-like AI Experience)
  -- ============================================================================
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "claude", -- or "openai", "azure", "copilot"
      auto_suggestions_provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022",
          extra_request_body = {
            temperature = 0.7,
            max_tokens = 4096,
          },
        },
        openai = {
          endpoint = "https://api.openai.com",
          model = "gpt-4",
          extra_request_body = {
            temperature = 0.7,
            max_tokens = 4096,
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      diff = {
        autojump = true,
        list_opener = "copen",
      },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- ============================================================================
  -- Neural (Another AI Code Assistant)
  -- ============================================================================
  {
    "dense-analysis/neural",
    enabled = false, -- Enable if you want to use Neural
    dependencies = {
      "MunifTanjim/nui.nvim",
      "ElPiloto/significant.nvim",
    },
    config = function()
      require("neural").setup({
        source = {
          openai = {
            api_key = vim.env.OPENAI_API_KEY,
          },
        },
      })
    end,
  },

  -- ============================================================================
  -- AstroCore Configuration for AI Integration
  -- ============================================================================
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      
      -- AI keybindings
      maps.n["<leader>a"] = { desc = "AI" }
      
      -- Copilot mappings
      maps.n["<leader>acp"] = { "<cmd>Copilot panel<cr>", desc = "Copilot Panel" }
      maps.n["<leader>acs"] = { "<cmd>Copilot status<cr>", desc = "Copilot Status" }
      maps.n["<leader>ace"] = { "<cmd>Copilot enable<cr>", desc = "Copilot Enable" }
      maps.n["<leader>acd"] = { "<cmd>Copilot disable<cr>", desc = "Copilot Disable" }
      
      -- CopilotChat mappings
      maps.n["<leader>acc"] = { "<cmd>CopilotChat<cr>", desc = "Copilot Chat" }
      maps.v["<leader>acc"] = { "<cmd>CopilotChat<cr>", desc = "Copilot Chat" }
      maps.n["<leader>acq"] = { "<cmd>CopilotChatClose<cr>", desc = "Close Copilot Chat" }
      maps.n["<leader>acr"] = { "<cmd>CopilotChatReset<cr>", desc = "Reset Copilot Chat" }
      
      -- ChatGPT mappings
      maps.n["<leader>ag"] = { desc = "ChatGPT" }
      maps.n["<leader>agg"] = { "<cmd>ChatGPT<cr>", desc = "ChatGPT" }
      maps.n["<leader>age"] = { "<cmd>ChatGPTEditWithInstruction<cr>", desc = "Edit with instruction" }
      maps.n["<leader>agr"] = { "<cmd>ChatGPTRun<cr>", desc = "ChatGPT Run" }
      maps.n["<leader>agx"] = { "<cmd>ChatGPTRun explain_code<cr>", desc = "Explain Code" }
      maps.n["<leader>ags"] = { "<cmd>ChatGPTRun summarize<cr>", desc = "Summarize" }
      maps.n["<leader>agf"] = { "<cmd>ChatGPTRun fix_bugs<cr>", desc = "Fix Bugs" }
      maps.n["<leader>ago"] = { "<cmd>ChatGPTRun optimize_code<cr>", desc = "Optimize Code" }
      maps.n["<leader>agd"] = { "<cmd>ChatGPTRun docstring<cr>", desc = "Add Docstring" }
      maps.n["<leader>agt"] = { "<cmd>ChatGPTRun add_tests<cr>", desc = "Add Tests" }
      
      maps.v["<leader>age"] = { "<cmd>ChatGPTEditWithInstruction<cr>", desc = "Edit with instruction" }
      maps.v["<leader>agr"] = { "<cmd>ChatGPTRun<cr>", desc = "ChatGPT Run" }
      maps.v["<leader>agx"] = { "<cmd>ChatGPTRun explain_code<cr>", desc = "Explain Code" }
      maps.v["<leader>ags"] = { "<cmd>ChatGPTRun summarize<cr>", desc = "Summarize" }
      maps.v["<leader>agf"] = { "<cmd>ChatGPTRun fix_bugs<cr>", desc = "Fix Bugs" }
      maps.v["<leader>ago"] = { "<cmd>ChatGPTRun optimize_code<cr>", desc = "Optimize Code" }
      maps.v["<leader>agd"] = { "<cmd>ChatGPTRun docstring<cr>", desc = "Add Docstring" }
      maps.v["<leader>agt"] = { "<cmd>ChatGPTRun add_tests<cr>", desc = "Add Tests" }
      
      -- Avante mappings
      maps.n["<leader>aa"] = { "<cmd>AvanteAsk<cr>", desc = "Avante Ask" }
      maps.v["<leader>aa"] = { "<cmd>AvanteAsk<cr>", desc = "Avante Ask" }
      maps.n["<leader>ae"] = { "<cmd>AvanteEdit<cr>", desc = "Avante Edit" }
      maps.v["<leader>ae"] = { "<cmd>AvanteEdit<cr>", desc = "Avante Edit" }
      maps.n["<leader>ar"] = { "<cmd>AvanteRefresh<cr>", desc = "Avante Refresh" }
      maps.n["<leader>at"] = { "<cmd>AvanteToggle<cr>", desc = "Avante Toggle" }
      maps.n["<leader>af"] = { "<cmd>AvanteFocus<cr>", desc = "Avante Focus" }
      maps.n["<leader>ac"] = { "<cmd>AvanteClear<cr>", desc = "Avante Clear" }
      maps.n["<leader>ab"] = { "<cmd>AvanteBuild<cr>", desc = "Avante Build" }
      maps.n["<leader>as"] = { "<cmd>AvanteSwitchProvider<cr>", desc = "Switch AI Provider" }
      maps.n["<leader>ax"] = { "<cmd>AvanteClose<cr>", desc = "Avante Close" }
      
      -- Codeium mappings (if enabled)
      maps.n["<leader>ak"] = { desc = "Codeium" }
      maps.n["<leader>ake"] = { "<cmd>Codeium Enable<cr>", desc = "Enable Codeium" }
      maps.n["<leader>akd"] = { "<cmd>Codeium Disable<cr>", desc = "Disable Codeium" }
      maps.n["<leader>akc"] = { "<cmd>Codeium Chat<cr>", desc = "Codeium Chat" }
      maps.n["<leader>aks"] = { "<cmd>Codeium Status<cr>", desc = "Codeium Status" }
      
      -- Universal AI accept function for Tab key
      opts.options = opts.options or {}
      opts.options.g = opts.options.g or {}
      opts.options.g.ai_accept = function()
        -- Try Copilot first
        if vim.fn["copilot#Accept"]() ~= "" then
          return true
        end
        -- Try Codeium
        local codeium_ok, _ = pcall(function()
          return vim.fn["codeium#Accept"]()
        end)
        if codeium_ok then
          return true
        end
        -- Try Avante
        local avante = require("avante")
        if avante and avante.is_suggestion_active() then
          avante.accept_suggestion()
          return true
        end
        return false
      end
      
      -- Configure Tab key to accept AI suggestions
      maps.i["<Tab>"] = {
        function()
          if vim.g.ai_accept and vim.g.ai_accept() then
            return ""
          elseif vim.fn["vsnip#available"](1) == 1 then
            return "<Plug>(vsnip-expand-or-jump)"
          elseif require("luasnip").expand_or_jumpable() then
            return "<Plug>luasnip-expand-or-jump"
          else
            return "<Tab>"
          end
        end,
        expr = true,
        silent = true,
        desc = "Accept AI suggestion or expand snippet",
      }
      
      return opts
    end,
  },
}