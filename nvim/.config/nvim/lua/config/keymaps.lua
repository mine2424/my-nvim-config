-- ========================================
-- Key Mappings
-- ========================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ========================================
-- Basic Operations
-- ========================================

-- Save
keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Quit
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force quit" })
keymap("n", "<leader>x", "<cmd>xa<cr>", { desc = "Save all and quit" })

-- Exit insert mode
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- ========================================
-- Clipboard
-- ========================================

-- System clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
keymap({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- Delete without yanking
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- ========================================
-- Navigation
-- ========================================

-- Scroll with centering
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Search with centering
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Line start/end
keymap({ "n", "v" }, "H", "^", { desc = "Go to line start" })
keymap({ "n", "v" }, "L", "$", { desc = "Go to line end" })

-- ========================================
-- Window Navigation (Tmux Integration)
-- ========================================
-- Note: vim-tmux-navigator handles Ctrl+h/j/k/l
-- These will be set up by the plugin

-- Fallback window navigation (if not using tmux-navigator)
-- keymap("n", "<C-h>", "<C-w>h", { desc = "Navigate left" })
-- keymap("n", "<C-j>", "<C-w>j", { desc = "Navigate down" })
-- keymap("n", "<C-k>", "<C-w>k", { desc = "Navigate up" })
-- keymap("n", "<C-l>", "<C-w>l", { desc = "Navigate right" })

-- ========================================
-- Window Management
-- ========================================

-- Split windows
keymap("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertically" })
keymap("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equal window size" })
keymap("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close window" })

-- Resize windows
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- ========================================
-- Buffer Management
-- ========================================

-- Navigate buffers
keymap("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Close buffers
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })
keymap("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete other buffers" })

-- ========================================
-- Text Editing
-- ========================================

-- Indent (keep selection in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Duplicate line
keymap("n", "<leader>j", "<cmd>t.<cr>", { desc = "Duplicate line down" })
keymap("n", "<leader>k", "<cmd>t.-1<cr>", { desc = "Duplicate line up" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ========================================
-- File Explorer (nvim-tree)
-- ========================================

keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
keymap("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file tree" })

-- ========================================
-- Telescope (File & Search)
-- ========================================

keymap("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
keymap("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })

-- ========================================
-- LSP
-- ========================================

-- Navigation
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
keymap("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

-- Hover & Signature
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
keymap("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
keymap("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- Code actions
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
keymap("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Rename
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })

-- Format
keymap("n", "<leader>f", vim.lsp.buf.format, { desc = "Format" })
keymap("v", "<leader>f", vim.lsp.buf.format, { desc = "Format selection" })

-- Diagnostics
keymap("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { desc = "List diagnostics" })

-- ========================================
-- Git (Gitsigns & Telescope)
-- ========================================

-- Telescope git
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })

-- Gitsigns (hunks) - will be set up in plugins/git.lua
-- keymap("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
-- keymap("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous hunk" })
-- keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
-- keymap("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
-- keymap("n", "<leader>gS", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })

-- ========================================
-- Terminal (Toggleterm)
-- ========================================

keymap("n", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
keymap("t", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })

-- ========================================
-- Trouble (Diagnostics)
-- ========================================

keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })

-- ========================================
-- Lazy (Plugin Manager)
-- ========================================

keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Lazy update" })
keymap("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Lazy sync" })

-- ========================================
-- Config Reload
-- ========================================

keymap("n", "<leader>R", function()
  -- Clear Lua module cache
  for module_name, _ in pairs(package.loaded) do
    if module_name:match("^config%.") or module_name:match("^plugins%.") then
      package.loaded[module_name] = nil
    end
  end
  
  -- Reload config
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end, { desc = "Reload config" })

-- Colorscheme picker
keymap("n", "<leader>cs", "<cmd>Telescope colorscheme<cr>", { desc = "Change colorscheme" })

-- LSP restart
keymap("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
