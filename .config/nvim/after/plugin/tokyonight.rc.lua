local g = vim.g
g.tokyonight_style = "night"
g.tokyonight_transparent = true
g.tokyonight_italic_functions = true
g.tokyonight_italic_comments = true

g.tokyonight_colors = {
  hint = 'orange',
  error = '#ff0000'
}

vim.cmd [[colorscheme tokyonight]]

local Color, colors, Group, groups, styles = require('colorbuddy').setup()

Color.new('black', '#000000')
Color.new('darkgray', '#333333')
Color.new('pink', '#ff99ff')

Group.new('CursorLine', colors.none, colors.darkgray:dark(), styles.NONE, colors.darkgray)
Group.new('CursorLineNr', colors.pink, colors.darkgray:dark(), styles.NONE, colors.darkgray)
Group.new('Visual', colors.none, colors.black, styles.reverse)

Color.new('cError', '#ff0000')
Color.new('cInfo', '#ffff00')
Color.new('cWarn', '#cc6d00')
Color.new('cHint', '#ff8800')

Group.new('DiagnosticVirtualTextError', colors.cError, colors.cError:dark():dark():dark(), styles.NONE)
Group.new('DiagnosticVirtualTextInfo', colors.cInfo, colors.cInfo:dark():dark():dark(), styles.NONE)
Group.new('DiagnosticVirtualTextWarn', colors.cWarn, colors.cWarn:dark():dark():dark(), styles.NONE)
Group.new('DiagnosticVirtualTextHint', colors.cHint, colors.cHint:dark():dark():dark(), styles.NONE)
Group.new('DiagnosticUnderlineError', colors.none, colors.none, styles.undercurl, colors.cError)
Group.new('DiagnosticUnderlineInfo', colors.none, colors.none, styles.undercurl, colors.cInfo)
Group.new('DiagnosticUnderlineWarn', colors.none, colors.none, styles.undercurl, colors.cWarn)
Group.new('DiagnosticUnderlineHint', colors.none, colors.none, styles.undercurl, colors.cHint)
