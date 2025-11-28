-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Buffer navigation
vim.keymap.set('n', '<leader>nb', '<cmd>bnext<CR>', { desc = '[N]ext [B]uffer' })
vim.keymap.set('n', '<leader>pb', '<cmd>bprevious<CR>', { desc = '[P]revious [B]uffer' })
vim.keymap.set('n', '<leader>db', '<cmd>bdelete<CR>', { desc = '[D]elete [B]uffer' })

-- Disable F1 help
vim.keymap.set('n', '<F1>', '<Nop>', { desc = 'Disable F1 help' })

-- Delete without yanking (d), cut with yanking (x)
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { desc = 'Delete (no yank)' })
vim.keymap.set('n', 'dd', '"_dd', { desc = 'Delete line (no yank)' })
vim.keymap.set({ 'n', 'v' }, 'D', '"_D', { desc = 'Delete to end (no yank)' })
vim.keymap.set({ 'n', 'v' }, 'x', 'd', { desc = 'Cut (yank)' })
vim.keymap.set('n', 'xx', 'dd', { desc = 'Cut line (yank)' })
vim.keymap.set({ 'n', 'v' }, 'X', 'D', { desc = 'Cut to end (yank)' })
