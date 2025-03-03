return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    indent = {
      enabled = true,
      animate = {
        enabled = false
      }
    },
    gitbrowse = {
      enabled = true,
      what = "file",
      branch = "HEAD"
    },
  },
  keys = {
      { '<leader>w', function() require("snacks").gitbrowse.open() end, mode = 'n', desc = "Open gitbrowse, ie open web", }
  }
}
