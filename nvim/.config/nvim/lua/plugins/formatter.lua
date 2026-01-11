-- ========================================
-- Formatter Configuration
-- ========================================

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Web development
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        
        -- Mobile development
        dart = { "dart_format" },
        kotlin = { "ktlint" },
        java = { "google-java-format" },
        swift = { "swift_format" },
        
        -- System programming
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        
        -- Scripting languages
        python = { "black", "isort" },
        ruby = { "rubocop" },
        
        -- Other
        lua = { "stylua" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
        
        -- Config files
        toml = { "taplo" },
      },
      
      -- Format on save
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      
      -- Formatter options
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },  -- 2 spaces indent
        },
        prettier = {
          prepend_args = { "--tab-width", "2" },
        },
      },
    },
    init = function()
      -- Toggle format on save
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          vim.notify("Format on save disabled", vim.log.levels.INFO)
        else
          vim.notify("Format on save enabled", vim.log.levels.INFO)
        end
      end, {
        desc = "Toggle format on save",
      })
      
      -- Disable format on save for current buffer
      vim.api.nvim_create_user_command("FormatToggleBuffer", function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        if vim.b.disable_autoformat then
          vim.notify("Format on save disabled for this buffer", vim.log.levels.INFO)
        else
          vim.notify("Format on save enabled for this buffer", vim.log.levels.INFO)
        end
      end, {
        desc = "Toggle format on save for current buffer",
      })
      
      -- Key mapping for toggle
      vim.keymap.set("n", "<leader>tf", "<cmd>FormatToggle<cr>", { desc = "Toggle format on save" })
      vim.keymap.set("n", "<leader>tF", "<cmd>FormatToggleBuffer<cr>", { desc = "Toggle format on save (buffer)" })
    end,
  },
}
