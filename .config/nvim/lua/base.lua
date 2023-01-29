local o = vim.opt
local w = vim.wo

vim.cmd('autocmd!')

vim.scriptencoding = 'utf-8'
o.encoding = 'utf-8'
o.fileencoding = 'utf-8'

vim.wo.number = true

o.title = true
o.autoindent = true
o.hlsearch = true
o.backup = false
o.showcmd = true
o.cmdheight = 1
o.laststatus = 2
o.expandtab = true
o.scrolloff = 10
o.shell = 'fish'
o.backupskip = '/tmp/*,/private/tmp/*'
o.inccommand = 'split'
o.ignorecase = true
o.smarttab = true
o.breakindent = true
o.shiftwidth = 2
o.tabstop = 2
o.ai = true -- Auto indent
o.si = true -- Smart indent
o.wrap = false
o.backspace = 'start,eol,indent'
o.path:append { '**' } -- Finding files - Search down into subfolders
o.wildignore:append { '*/node_modules/*' }
-- o.cursorline = true
o.clipboard:append { 'unnamedplus' }
o.mouse = 'a'

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})

-- Add asterisks in block comments
o.formatoptions:append { 'r' }
