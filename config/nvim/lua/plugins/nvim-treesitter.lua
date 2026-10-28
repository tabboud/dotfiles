-- nvim-treesitter.lua
local languages = {
	"go",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"rust",
	"vim",
	"vimdoc",
	"yaml",
}

-- Map languages to filetype patterns
local filetypes = vim.iter(languages)
	:map(function(lang)
		return vim.treesitter.language.get_filetypes(lang)
	end)
	:flatten()
	:totable()

require("nvim-treesitter").setup({
	ensure_installed = languages,
})

-- Enable tree-sitter after opening a file for a target language
vim.api.nvim_create_autocmd("FileType", {
	desc = "Setup treesitter for a buffer",
	group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true }),
	pattern = filetypes,
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
