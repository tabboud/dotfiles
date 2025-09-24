return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>k", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
			{ "<leader>f", "<cmd>Neotree reveal<cr>", desc = "NeoTree" },
		},
		config = function()
			require("neo-tree").setup({
				use_default_mappings = true,
				-- Disable since it's hard to parse on large projects
				-- nesting_rules = {
				--   ["go"] = {
				--     pattern = "(.*)%.go$",    -- <-- Lua pattern with capture
				--     files = { "%1_test.go" }, -- <-- glob pattern with capture
				--   },
				-- },
				source_selector = {
					winbar = true,
					sources = {
						{ source = "filesystem" },
						-- { source = "git_status" },
					},
				},
				-- hide stats columns when using "width = 'fit_content'
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
						-- width = 'fit_content',
						width = 50,
						-- max_width = 50,
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
									-- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
									-- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
									local node = state.tree:get_node()
									local filepath = node:get_id()

									local results = {
										filepath, -- absolute path to file (e.g. /Users/user/project/cmd/main.go)
										vim.fn.fnamemodify(filepath, ":."), -- path relative to CWD, usually the root of a git repo (e.g. cmd/main.go)
										vim.fn.fnamemodify(filepath, ":t"), -- Just the file name (main.go if given a path of cmd/main.go)
									}

									vim.ui.select(results, { prompt = "Select a path to copy" }, function(choice)
										if not choice then
											vim.notify("Invalid Choice", vim.log.levels.ERROR)
										end
										-- store value into system clipboard register
										vim.fn.setreg("+", choice)
									end)
								end,
							},
						},
					},
				},
			})
		end,
	},
}
