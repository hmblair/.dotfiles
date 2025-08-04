vim.g.mapleader = " "
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show [e]rror in floating window', silent = true })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>pv', '<cmd>NvimTreeToggle<CR>')

vim.keymap.set('n', '<leader>nb', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>pb', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>db', ':bdelete<CR>', { noremap = true, silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fzf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fzg', builtin.live_grep, { desc = 'Telescope live grep' })

vim.api.nvim_set_keymap('n', '<F1>', '<NOP>', { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "fe", "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "Fe", "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "gh", ":lua _go_to_header()<CR>", { noremap = true, silent = true })

function _go_to_header()
    local filetype = vim.bo.filetype
    if filetype ~= "c" and filetype ~= "cpp" then
        print("Not a C/C++ file")
        return
    end

    local file = vim.fn.expand("%:p")
    local header = file:gsub("%.cpp$", ".hpp"):gsub("%.c$", ".h")

    if vim.fn.filereadable(header) == 1 then
        vim.api.nvim_command("edit " .. header)
        vim.api.nvim_win_set_cursor(0, {1, 0})
    else
        header = file:gsub("%.cpp$", ".h"):gsub("%.c$", ".h")
        if vim.fn.filereadable(header) == 1 then
            vim.api.nvim_command("edit " .. header)
            vim.api.nvim_win_set_cursor(0, {1, 0})
        else
            print("Header file not found")
        end
    end
end
