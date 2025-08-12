return {
  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'nvim-tree/nvim-web-devicons',
      "SmiteshP/nvim-navic",
      "nvim-lua/plenary.nvim", -- For additional schemasa function
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

      local lspconfig = require('lspconfig')
      local navic = require("nvim-navic")
      local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lspconfig.nil_ls.setup { capabilities = capabilities }
      lspconfig.rust_analyzer.setup { capabilities = capabilities }
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
      lspconfig.yamlls.setup {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              kubernetes = "*.yaml",
              ["https://json.schemastore.org/any.json"] = "values.{yml,yaml}", -- TODO this doesnt work
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
              ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
              ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
              ["https://raw.githubusercontent.com/budimanjojo/talhelper/master/pkg/config/schemas/talconfig.json"] = "talconfig.{yml,yaml}",
            },
          }
        },
        on_attach = function(client, bufnr)
          navic.attach(client, bufnr)
        end
      }
      lspconfig.ruff.setup{}
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
      { "<leader>y", function() require('user.kubernetes-schema').init() end ,     mode = { "n" },              desc = "Set yamlls comment" },
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "zbirenbaum/copilot.lua",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require 'luasnip'

      cmp.setup({
        map_complete = true;
        sources = {
          { name = "copilot"},
          { name = "nvim_lsp", },
          { name = 'luasnip', },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
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

  -- "AI"
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua"
    },
    config = function ()
      require("copilot_cmp").setup()
    end
  }
}
