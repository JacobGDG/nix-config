return {
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 10000,
    config = function()
      vim.cmd.set "t_Co=256"
      vim.o.background = "dark"
      vim.cmd.colorscheme "gruvbox"
    end,
  },
}
