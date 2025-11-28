-- Preserve undos between sessions
vim.opt.undofile = true

-- Search case-sensitive only when uppercase letters are present
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Highlight the current line
vim.opt.cursorline = true

-- Minimum distance of cursor to boundary before scrolling begins
vim.opt.scrolloff = 10

vim.g.have_nerd_font = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.opt.inccommand = "split"
vim.opt.signcolumn = 'yes'

-- Show (relative) line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 100
    })
  end,
})

-- Yank to system clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamed,unnamedplus'
end)

-- Open files to most recent line number
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if last_pos > 0 and last_pos <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, {last_pos, 0})
    end
  end
})

-- No shortmess
vim.opt.shortmess:append("I")
