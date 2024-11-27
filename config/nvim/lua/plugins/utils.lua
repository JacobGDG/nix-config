return {
  'mrjones2014/smart-splits.nvim',

  -- netrw but a buffer
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('oil').setup {
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true
        },

        use_default_keymaps = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["g."] = "actions.toggle_hidden",
          ["<leader>l"] = "actions.refresh",
          ['yp'] = {
              desc = 'Copy filepath to system clipboard',
              callback = function ()
                  require('oil.actions').copy_entry_path.callback()
                  vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
              end,
          },
        },
      }
    end,
    keys = {
      {
        '-',
        '<CMD>Oil<CR>',
        mode = 'n',
        desc = "Open parent directory",
      }
    }
  },

  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').create_default_mappings()
    end
  },
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "kkharji/sqlite.lua" }
    },
    opts = {
      ring = { storage = "sqlite" },
      system_clipboard = {
        sync_with_ring = true,
        clipboard_register = "+",
      }
    },
    keys = {
      { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
      { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
  },
}
