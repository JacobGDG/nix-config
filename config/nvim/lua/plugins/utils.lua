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
          show_hidden = true,
          is_always_hidden = function(name)
            return name == ".."
          end,
        },

        use_default_keymaps = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<leader>v"] = { "actions.select", opts = { vertical = true } },
          ["-"] = "actions.parent",
          ["~"] = "actions.open_cwd",
          ["g."] = "actions.toggle_hidden",
          ["<leader>l"] = "actions.refresh",
          ['yp'] = {
              desc = 'Copy filepath to system clipboard',
              callback = function ()
                local entry = require('oil').get_cursor_entry()
                local dir = require('oil').get_current_dir()
                local name = entry.name
                if entry.type == "directory" then
                  name = name .. "/"
                end
                local ab_path = dir .. name
                local rel_path = vim.fn.fnamemodify(ab_path, ":.")
                vim.fn.setreg("+", rel_path)
              end,
          },
          ['cd']= {
              desc = 'CD into this directory in TMUX pane 2',
              callback = function ()
                local dir = require('oil').get_current_dir()
                io.popen(string.format('tmux send-keys -t 2 "cd %s" Enter', dir))
                io.popen('tmux select-pane -t 2')
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
    config = function()
      require('yanky').setup {
        system_clipboard = {
          sync_with_ring = true,
          clipboard_register = "+",
        }
      }
    end,
    keys = {
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

  {
    "gregorias/coerce.nvim",
    config = true,
  },
}
