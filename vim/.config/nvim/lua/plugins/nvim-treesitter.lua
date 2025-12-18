return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		event = { "VeryLazy" },
		lazy = false,
		cmd = { "TSUpdate", "TSInstall" },
		opts = {
			ensure_installed = {
				"go",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"rust",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
				callback = function(event)
					local ok, nvim_treesitter = pcall(require, "nvim-treesitter")
					if not ok then
						return
					end

					-- install TS language based on filetype before starting
					local ft = vim.bo[event.buf].ft
					local lang = vim.treesitter.language.get_lang(ft)
					nvim_treesitter.install({ lang }):await(function(err)
						if err then
							vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
							return
						end

						-- highlighting
						pcall(vim.treesitter.start, event.buf)

						-- folds
						vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.wo[0][0].foldmethod = "expr"
					end)
				end,
			})
		end,
	},
}
