return {
  'kwkarlwang/bufresize.nvim',
  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      { "meuter/lualine-so-fancy.nvim", pin = true },
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        }
      },
      sections = {
        lualine_a = {'fancy_mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
          {
            'filename',
            path = 1,
          },
          'fancy_macro'
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'location', 'progress'},
        lualine_z = {'fancy_lsp_servers'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            path = 1,
          }
        },
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'oil' },
    }
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
