-- Replace <C-l> in netrw, which usually refreshes
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, {
  silent = true, buffer = true
})
