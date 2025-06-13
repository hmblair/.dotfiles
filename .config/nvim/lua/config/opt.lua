-- Colour scheme
vim.cmd[[colorscheme tokyonight-night]]

-- Preserve undos between sessions
vim.opt.undofile = true

-- Search case-sensitive only when uppercase letters are present
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

-- Highlight the current line
vim.opt.cursorline = true

-- Minimum distance of cursor to boundary before scrolling begins
vim.opt.scrolloff = 10

vim.g.have_nerd_font = true
vim.opt.mouse = 'a'

-- Show (relative) line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = "split"

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=100}
  augroup END
]], false)

-- Yank to system clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamed,unnamedplus'
end)
