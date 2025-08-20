return {
  { -- keybindings
    'mrjones2014/legendary.nvim',
    priority = 9999,
    lazy = false,
    keys = {
      { "kj",        "<ESC>:w<CR>",      mode = "i", desc = "Save file without ESC" },
      { "<leader>s", "\"_diwP",          mode = "n", desc = "Stamp default register onto word" },
      { "<Up>",      "<Nop>",            mode = "n", silent = true },
      { "<Down>",    "<Nop>",            mode = "n", silent = true },
      { "<Left>",    "<Nop>",            mode = "n", silent = true },
      { "<Right>",   "<Nop>",            mode = "n", silent = true },
      { "<leader>y", "\"+y",             mode = "n", silent = true },
      { "<leader>y", "\"+y",             mode = "v", silent = true },
      { "n",         "nzzzv",            mode = "n", silent = true },
      { "N",         "Nzzzv",            mode = "n", silent = true },
      { "J",         ":m '>+1<CR>gv=gv", mode = "v", silent = true },
      { "K",         ":m '<-2<CR>gv=gv", mode = "v", silent = true },
      { "J",         "mzJ`z",            mode = "n", silent = true },
      { "<C-d>",     "<C-d>zz",          mode = "n", silent = true },
      { "<C-u>",     "<C-u>zz",          mode = "n", silent = true },
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
