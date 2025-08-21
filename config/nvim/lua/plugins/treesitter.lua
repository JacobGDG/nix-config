return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        highlight = { enable = true },
        indent = {
          enable = false,
          disable = { "python" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/7385
        },
        with_sync = true,
        ensure_installed = {
          "nix",
          "bash",
          "diff",
          "hcl",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "just",
          "lua",
          "luadoc",
          "luap",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "ruby",
          "terraform",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        }
      })

      -- tf can mean multiple things, so we need to specify the filetype
      vim.filetype.add({
        extension = {
          tf = "terraform"
        }
      })
    end
  },
}
