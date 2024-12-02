return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end
  },

  {
    'rhysd/committia.vim',
    event = 'BufReadPre COMMIT_EDITMSG',
    init = function()
      -- See: https://github.com/rhysd/committia.vim#variables
      vim.g.committia_min_window_width = 30
      vim.g.committia_edit_window_width = 80
    end,
    config = function()
      vim.g.committia_hooks = {
        edit_open = function()
          vim.cmd.resize(10)
          local opts = {
            buffer = vim.api.nvim_get_current_buf(),
            silent = true,
          }
          local function map(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, opts)
          end
          map('n', 'q', '<cmd>quit<CR>')
          map('i', '<C-d>', '<Plug>(committia-scroll-diff-down-half)')
          map('n', '<C-d>', '<Plug>(committia-scroll-diff-down-half)')
          map('i', '<C-u>', '<Plug>(committia-scroll-diff-up-half)')
          map('n', '<C-u>', '<Plug>(committia-scroll-diff-up-half)')
          vim.cmd("highlight ColorColumn ctermbg=0 guibg=DarkGreen")
          vim.api.nvim_set_option_value("colorcolumn", "51", {})
        end,
        status_open = function()
          local opts = {
            buffer = vim.api.nvim_get_current_buf(),
            silent = true,
          }
          local function map(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, opts)
          end
          map('n', 'q', '<cmd>quit<CR>')
        end,
        diff_open = function()
          local opts = {
            buffer = vim.api.nvim_get_current_buf(),
            silent = true,
          }
          local function map(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, opts)
          end
          map('n', 'q', '<cmd>quit<CR>')
        end
      }
    end,
  },
}
