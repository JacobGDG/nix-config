return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim"
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            "vcr_cassettes"
          }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            }

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
          }
        }
      }
      require("telescope").load_extension("yank_history")
      require("telescope").load_extension("ui-select")
    end,
    keys = {
      {
        '<leader>o',
        function()
          require('telescope.builtin').find_files()
        end,
        mode = { 'n' },
        desc = "Find file",
      },
      {
        '<leader>f',
        function()
          require('telescope.builtin').live_grep()
        end,
        mode = { 'n' },
        desc = "Find string",
      },
      {
        '<leader>b',
        function()
          require('telescope.builtin').buffers()
        end,
        mode = { 'n' },
        desc = "Find buffer",
      },
      {
        '<leader>h',
        function()
          require('telescope.builtin').help_tags()
        end,
        mode = { 'n' },
        desc = "Get help!",
      },
      { "<leader>k",   ":Legendary keymaps<CR>", mode = "n", desc = "Find keymaps" },
    }
  },

}
