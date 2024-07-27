return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				svelte = { "prettierd" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				graphql = { "prettier" },
				java = { "google-java-format" },
				kotlin = { "ktlint" },
				ruby = { "standardrb" },
				markdown = { "prettier" },
				erb = { "htmlbeautifier" },
				go = { "gofmt" },
				html = { "prettier" },
				bash = { "beautysh" },
				proto = { "buf" },
				rust = { "rustfmt" },
				yaml = { "prettier" },
				toml = { "taplo" },
				css = { "prettier" },
				scss = { "prettier" },
				sh = { "shellcheck" },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
