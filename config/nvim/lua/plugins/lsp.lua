return {
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require 'luasnip'

      cmp.setup({
        map_complete = true;
        sources = {
          { name = "nvim_lsp", },      -- from language server
          { name = 'luasnip', },
          { name = "buffer", },        -- nvim-cmp source for buffer words
          { name = "path", },          -- nvim-cmp source for path
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      local lsp_defaults = require('lspconfig').util.default_config

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

      local lspconfig = require('lspconfig')
      local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

      lspconfig.nil_ls.setup { capabilities = capabilities }
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            format = {
              enable = true,
            },
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim", },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
    keys = {
      { "K",         vim.lsp.buf.hover,           desc = "LSP Hover" },
      { "gd",        vim.lsp.buf.definition,      desc = "LSP Goto Definition" },
      { "gc",        vim.lsp.buf.declaration,     desc = "LSP Goto Declaration" },
      { "gi",        vim.lsp.buf.implementation,  desc = "LSP Goto Implementation" },
      { "gt",        vim.lsp.buf.type_definition, desc = "LSP Goto Type Definition" },
      { "gr",        vim.lsp.buf.references,      desc = "LSP References" },
      { "<leader>e", vim.diagnostic.open_float,   desc = "Show Diagnostic" },
      { "Q",         vim.diagnostic.setloclist,   desc = "Open Diagnostic Loclist" },
      { "<C-n>",     vim.diagnostic.goto_next,    desc = "Goto Next Diagnostic" },
      { "<C-b>",     vim.diagnostic.goto_prev,    desc = "Goto Next Diagnostic" },
      { "<leader>r", vim.lsp.buf.rename,          desc = "Rename" },
      { "<leader>a", vim.lsp.buf.code_action,     mode = { "n", "v" },              desc = "Goto Next Diagnostic" },

    },
  }
}