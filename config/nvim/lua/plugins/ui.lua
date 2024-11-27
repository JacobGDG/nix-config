return {
  'kwkarlwang/bufresize.nvim',

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    depends = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      require("lualine").setup {
        extensions = { 'oil' },
      }
    end
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    lazy = true,
    ft = { 'markdown' }
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  }
}
