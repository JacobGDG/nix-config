return {
  {
		'numToStr/Comment.nvim',
		dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
		opts = function(_, opts)
			local ok, tcc =
				pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
			if ok then
				opts.pre_hook = tcc.create_pre_hook()
			end
		end,
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
	}
}
