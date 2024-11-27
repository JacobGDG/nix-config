--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there"s only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {"menuone", "noselect", "noinsert"}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option("updatetime", 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Completion Plugin Setup
local cmp = require("cmp")
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<Tab>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = "copilot", },
    { name = "nvim_lsp", },      -- from language server
    { name = "buffer", },        -- nvim-cmp source for buffer words
    { name = "path", },          -- nvim-cmp source for path
    -- { name = "vsnip", keyword_length = 2 },         -- nvim-cmp source for vim-vsnip
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {"menu", "abbr", "kind"},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = "",
              -- vsnip = "⋗",
              buffer = "",
              path = "",
              copilot = "",
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})
