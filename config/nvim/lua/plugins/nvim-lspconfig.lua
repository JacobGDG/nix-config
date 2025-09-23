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
      -- { "<C-n>",     vim.diagnostic.goto_next,    desc = "Goto Next Diagnostic" },
      { "<C-b>",     vim.diagnostic.goto_prev,    desc = "Goto Next Diagnostic" },
      { "<leader>r", vim.lsp.buf.rename,          desc = "Rename" },
      { "<leader>a", vim.lsp.buf.code_action,     desc = "Goto Next Diagnostic", mode = { "n", "v" } },

      { "<leader>y", function() require('scripts.kubernetes-schemas').init() end, mode = { "n" }, desc = "Set yamlls comment" },
    },
  },

}
