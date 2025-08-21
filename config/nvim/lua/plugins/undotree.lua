return {
  {
    "mbbill/undotree",
    keys = {
      { '<leader>u', function() vim.cmd.UndotreeToggle() end, mode = 'n', desc = "Toggle undotree" }
    },
    config = function()
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true
    end,
  }
}
