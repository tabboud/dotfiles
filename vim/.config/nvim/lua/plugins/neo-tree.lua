-- neo-tree.lua
require("neo-tree").setup({
	use_default_mappings = true,
	source_selector = {
		winbar = true,
		sources = {
			{ source = "filesystem" },
		},
	},
	default_component_configs = {
		file_size = { enabled = false },
		type = { enabled = false },
		last_modified = { enabled = false },
		created = { enabled = false },
	},
	filesystem = {
		follow_current_file = {
			enabled = true,
		},
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = true,
			never_show = {
				".DS_Store",
			},
		},
		window = {
			width = 50,
			mappings = {
				["S"] = {
					desc = "Search in path",
					command = function(state)
						local node = state.tree:get_node()
						local path = vim.fn.fnamemodify(node.path, ":.")
						Snacks.picker.grep(
							---@type snacks.picker.Config
							{
								dirs = { path },
							}
						)
					end,
				},
				["Y"] = {
					desc = "Yank filepath",
					command = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()

						local results = {
							filepath,
							vim.fn.fnamemodify(filepath, ":."),
							vim.fn.fnamemodify(filepath, ":t"),
						}

						vim.ui.select(results, { prompt = "Select a path to copy" }, function(choice)
							if not choice then
								vim.notify("Invalid Choice", vim.log.levels.ERROR)
							end
							vim.fn.setreg("+", choice)
						end)
					end,
				},
			},
		},
	},
})

vim.keymap.set("n", "<leader>k", "<cmd>Neotree toggle<cr>", { desc = "NeoTree" })
vim.keymap.set("n", "<leader>f", "<cmd>Neotree reveal<cr>", { desc = "NeoTree" })
