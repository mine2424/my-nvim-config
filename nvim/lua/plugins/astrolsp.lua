-- ========================================
-- AstroLSP Configuration
-- ========================================
-- LSP configuration and keymaps

return {
	"AstroNvim/astrolsp",
	---@type AstroLSPOpts
	opts = {
		-- ========================================
		-- Features
		-- ========================================
		features = {
			autoformat = true, -- Enable auto formatting on save
			codelens = true, -- Enable codelens refresh
			inlay_hints = false, -- Enable inlay hints (can be toggled)
			semantic_tokens = true, -- Enable semantic token highlighting
		},

		-- ========================================
		-- Capabilities
		-- ========================================
		capabilities = {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		},

		-- ========================================
		-- Formatting
		-- ========================================
		formatting = {
			format_on_save = {
				enabled = true,
				allow_filetypes = {},
				ignore_filetypes = {},
			},
			disabled = {},
			timeout_ms = 1000,
			filter = function(client)
				-- Disable formatting for certain LSP clients
				local disabled_clients = {
					"tsserver",
					"lua_ls",
				}
				return not vim.tbl_contains(disabled_clients, client.name)
			end,
		},

		-- ========================================
		-- LSP Handlers
		-- ========================================
		handlers = {
			-- Hover handler with border
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			-- Signature help handler with border
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
		},

		-- ========================================
		-- LSP Mappings
		-- ========================================
		mappings = {
			n = {
				-- LSP actions
				["<leader>la"] = { vim.lsp.buf.code_action, desc = "Code action" },
				["<leader>lr"] = { vim.lsp.buf.rename, desc = "Rename" },
				["<leader>lf"] = { vim.lsp.buf.format, desc = "Format" },
				["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "LSP info" },
				["<leader>lI"] = { "<cmd>LspInstall<cr>", desc = "LSP install" },
				["<leader>lR"] = { "<cmd>LspRestart<cr>", desc = "LSP restart" },

				-- Diagnostics
				["<leader>ld"] = { vim.diagnostic.open_float, desc = "Show diagnostic" },
				["[d"] = { vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
				["]d"] = { vim.diagnostic.goto_next, desc = "Next diagnostic" },
				["<leader>lD"] = { vim.diagnostic.setloclist, desc = "Diagnostic list" },

				-- Go to
				["gd"] = { vim.lsp.buf.definition, desc = "Go to definition" },
				["gD"] = { vim.lsp.buf.declaration, desc = "Go to declaration" },
				["gi"] = { vim.lsp.buf.implementation, desc = "Go to implementation" },
				["gr"] = { vim.lsp.buf.references, desc = "Go to references" },
				["gt"] = { vim.lsp.buf.type_definition, desc = "Go to type definition" },

				-- Documentation
				["K"] = { vim.lsp.buf.hover, desc = "Hover documentation" },
				["<leader>lk"] = { vim.lsp.buf.signature_help, desc = "Signature help" },

				-- Workspace
				["<leader>lwa"] = { vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
				["<leader>lwr"] = { vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
				["<leader>lwl"] = {
					function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end,
					desc = "List workspace folders",
				},
			},
			v = {
				["<leader>la"] = { vim.lsp.buf.code_action, desc = "Code action" },
				["<leader>lf"] = { vim.lsp.buf.format, desc = "Format selection" },
			},
		},

		-- ========================================
		-- On Attach Function
		-- ========================================
		on_attach = function(client, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

			-- Highlight references under cursor
			if client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
				vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = "lsp_document_highlight",
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = "lsp_document_highlight",
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,

		-- ========================================
		-- LSP Server Configurations
		-- ========================================
		config = {
			-- TypeScript/JavaScript
			tsserver = {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},

			-- Lua
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
						},
						telemetry = { enable = false },
					},
				},
			},

			-- Python
			pyright = {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			},

			-- Rust
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							runBuildScripts = true,
						},
						checkOnSave = {
							allFeatures = true,
							command = "clippy",
							extraArgs = { "--no-deps" },
						},
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
					},
				},
			},

			-- Go
			gopls = {
				settings = {
					gopls = {
						gofumpt = true,
						codelenses = {
							gc_details = false,
							generate = true,
							regenerate_cgo = true,
							run_govulncheck = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						analyses = {
							fieldalignment = true,
							nilness = true,
							unusedparams = true,
							unusedwrite = true,
							useany = true,
						},
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
						semanticTokens = true,
					},
				},
			},
		},
	},
}
