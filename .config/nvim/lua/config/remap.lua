vim.g.mapleader = " "
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>pv', '<cmd>NvimTreeToggle<CR>')

vim.keymap.set('n', '<leader>nb', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>pb', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>db', ':bdelete<CR>', { noremap = true, silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fzf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fzg', builtin.live_grep, { desc = 'Telescope live grep' })

vim.api.nvim_set_keymap('n', '<F1>', '<NOP>', { noremap = true, silent = true })
