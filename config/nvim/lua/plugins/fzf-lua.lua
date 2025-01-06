return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    cmd = "FzfLua",
    keys = {
      {
        '<leader>f', -- for (generic) find
        function()
          require('fzf-lua').builtin()
        end,
        mode = { 'n' },
        desc = "Find string",
      },
      {
        '<leader>o', -- for open
        function()
          require('fzf-lua').files()
        end,
        mode = { 'n' },
        desc = "Find file",
      },
      {
        '<leader>g', -- for grep
        function()
          require('fzf-lua').live_grep()
        end,
        mode = { 'n' },
        desc = "Find string",
      },
      {
        'z=', -- replace existing key
        function()
          require('fzf-lua').spell_suggest()
        end,
        mode = { 'n' },
        desc = "Fix spelling",
      },
    }
  },
}
