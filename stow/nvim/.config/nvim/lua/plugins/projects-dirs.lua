return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				sources = {
					lines = {
						format = function(item)
							return vim.tbl_filter(function(part)
								return part.virtual ~= true
							end, require("snacks.picker.format").lines(item))
						end,
					},
					projects = {
						dev = { "~/Projects", "~/Work" },
					},
				},
			},
		},
	},
}
