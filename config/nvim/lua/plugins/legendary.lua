return {
  { -- keybindings
    'mrjones2014/legendary.nvim',
    priority = 9999,
    lazy = false,
    keys = {
      { "kj",          "<ESC>:w<CR>",            mode = "i", desc = "Save file without ESC" },
      { "<leader>s",   "\"_diwP",                mode = "n", desc = "Stamp default register onto word" },
      { "<Up>",        "<Nop>",                  mode = "n", silent = true },
      { "<Down>",      "<Nop>",                  mode = "n", silent = true },
      { "<Left>",      "<Nop>",                  mode = "n", silent = true },
      { "<Right>",     "<Nop>",                  mode = "n", silent = true },
    },
    config = function()
      require('legendary').setup({
        extensions = {
          lazy_nvim = true,
          smart_splits = {}
        }
      })
    end
  },
}
