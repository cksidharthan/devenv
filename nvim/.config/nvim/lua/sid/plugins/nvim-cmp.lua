return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-path", -- source for file system paths
		"onsails/lspkind-nvim", -- pictograms in completion menu
		"luckasRanarison/tailwind-tools.nvim", -- tailwindcss classes
	},
	config = function()
		local cmp = require("cmp")
		local types = require("cmp.types")

		-- Function to sort LSP snippets, so that they appear at the end of LSP suggestions
		local function deprioritize_snippet(entry1, entry2)
			if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
				return false
			end
			if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
				return true
			end
		end

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-b>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				-- { name = "luasnip" }, -- snippets
				-- { name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),

			sorting = {
				priority_weight = 2, -- sort by source priority
				comparators = {
					deprioritize_snippet, -- sort snippets last
					cmp.config.compare.offset, -- sort by cursor position
					cmp.config.compare.exact, -- sort by exact match
					cmp.config.compare.score, -- sort by score
					cmp.config.compare.kind, -- sort by kind
					cmp.config.compare.length, -- sort by length
					cmp.config.compare.order, -- sort by order
				},
			},
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				expandable_indicator = false,
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind = require("lspkind").cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						before = require("tailwind-tools.cmp").lspkind_format,
					})(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					kind.kind = " " .. (strings[1] or "") .. " "
					kind.menu = "    (" .. (strings[2] or "") .. ")"

					return kind
				end,
			},
		})
	end,
}
