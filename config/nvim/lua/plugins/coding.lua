return {
  -- LSP
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
          ensure_installed = { "tflint" },
        })
    end
  }, -- LSP

  -- AUTO COMPLETE

  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" } }, -- Autocomplete
}
