return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            "vcr_cassettes"
          }
        },
        pickers = {
          colorscheme = {
            enable_preview = true
          }
        },
      }
      require("telescope").load_extension("yank_history")
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
        'z=',
        function()
          require('telescope.builtin').spell_suggest()
        end,
        mode = { 'n' },
        desc = "Fix spelling",
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
      {
        '<leader>k',
        function()
          require('telescope.builtin').keymaps()
        end,
        mode = { 'n' },
        desc = "Get keymaps!",
      },
      {
        '<leader>y',
        "<CMD>Telescope yaml_schema<CR>",
        mode = { 'n' },
        desc = "Set YAML Schame",
      },
    }
  },

}
