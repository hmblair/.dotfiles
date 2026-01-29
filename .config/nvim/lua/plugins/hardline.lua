return {
  'ojroques/nvim-hardline',
  config = function()
    local common = require('hardline.common')
    local function mode_without_spell()
      local mode = common.modes[vim.fn.mode()] or common.modes['?']
      local paste = vim.o.paste and ' PASTE' or ''
      return mode.text .. paste
    end

    require('hardline').setup({
      bufferline = false,
      sections = {
        { class = 'mode', item = mode_without_spell },
        { class = 'high', item = require('hardline.parts.git').get_item, hide = 100 },
        { class = 'med', item = require('hardline.parts.filename').get_item },
        '%<',
        { class = 'med', item = '%=' },
        { class = 'low', item = require('hardline.parts.wordcount').get_item, hide = 100 },
        { class = 'error', item = require('hardline.parts.lsp').get_error },
        { class = 'warning', item = require('hardline.parts.lsp').get_warning },
        { class = 'high', item = require('hardline.parts.filetype').get_item, hide = 60 },
        { class = 'mode', item = require('hardline.parts.line').get_item },
      },
    })
  end,
}
