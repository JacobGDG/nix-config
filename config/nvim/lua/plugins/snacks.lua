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
    zen = {
      enabled = true,
      toggles = {
        dim = true,
      }
    },
    dim = {
      animate = {
        enabled = false,
      },
    },
  },
  keys = {
    { '<leader>w', function() require("snacks").gitbrowse.open() end, mode = 'n', desc = "Open gitbrowse, ie open web", },
    { "<leader>z",  function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },
  }
}
