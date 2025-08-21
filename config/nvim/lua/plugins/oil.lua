return {
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
                io.popen(string.format('tmux send-keys -t :.$(tmux-other-pane) "cd %s" Enter', dir))
                io.popen('tmux select-pane -t :.$(tmux-other-pane)')
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
}
