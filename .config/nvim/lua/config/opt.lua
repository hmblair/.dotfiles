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

-- Yank to system clipboard (with OSC 52 support for SSH)
vim.schedule(function()
  vim.opt.clipboard = 'unnamed,unnamedplus'
end)

-- Use OSC 52 for clipboard when in SSH session (works with most terminals)
if vim.env.SSH_CONNECTION then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

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

-- Auto-reload files changed outside of Neovim
vim.opt.autoread = true
local timer = vim.uv.new_timer()
timer:start(0, 1000, vim.schedule_wrap(function()
  if vim.fn.mode() ~= 'c' then
    vim.cmd('checktime')
  end
end))

-- Spell checking for tex files only (harper-ls handles other prose filetypes)
vim.g.spell_lang = "en_us"
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = vim.g.spell_lang
  end,
})

-- Toggle between US and GB English
vim.keymap.set('n', '<leader>sl', function()
  if vim.g.spell_lang == "en_us" then
    vim.g.spell_lang = "en_gb"
  else
    vim.g.spell_lang = "en_us"
  end
  vim.opt_local.spelllang = vim.g.spell_lang
  -- Update harper-ls
  for _, client in ipairs(vim.lsp.get_clients({ name = "harper_ls" })) do
    client.config.settings["harper-ls"].dialect = vim.g.spell_lang == "en_us" and "American" or "British"
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
  print("Spell language: " .. vim.g.spell_lang)
end, { desc = 'Toggle [S]pell [L]anguage (US/GB)' })

-- Load skeleton files for new buffers
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.tex',
  callback = function()
    local skel = vim.fn.stdpath('config') .. '/skeletons/tex.skel'
    if vim.fn.filereadable(skel) == 1 then
      vim.cmd('0read ' .. skel)
      vim.cmd('normal! Gdd')
      vim.fn.search('\\\\title{')
      vim.cmd('normal! f{l')
    end
  end,
})
