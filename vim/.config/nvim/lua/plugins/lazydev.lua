return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		dependencies = {
			{
				"DrKJeff16/wezterm-types",
				lazy = true,
				version = false, -- Get the latest version
			},
		},
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
		},
	},
	-- blink addition to add cmp completion sources for require statements and module annotations
	{
		"saghen/blink.cmp",
		enabled = true,
		opts = {
			sources = {
				-- add lazydev to your completion providers
				default = { "lazydev" },
				providers = {
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
		},
	},
}
