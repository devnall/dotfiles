" nordicpine.vim — dual-mode colorscheme (NordicPine dark / AlpineDawn light)
" Requires 256-color terminal or termguicolors

hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "nordicpine"

if &background ==# "dark"
  " ── NordicPine (dark) ──────────────────────────────────────────────

  " Core
  hi Normal       guifg=#c6e0df guibg=#0f111a ctermfg=152 ctermbg=233
  hi Comment      guifg=#343b51 guibg=NONE    ctermfg=237 ctermbg=NONE gui=italic cterm=italic
  hi NonText      guifg=#343b51 guibg=NONE    ctermfg=237 ctermbg=NONE
  hi SpecialKey   guifg=#343b51 guibg=NONE    ctermfg=237 ctermbg=NONE

  " Syntax — literals
  hi Constant     guifg=#e6cc6f guibg=NONE ctermfg=186 ctermbg=NONE
  hi String       guifg=#e6cc6f guibg=NONE ctermfg=186 ctermbg=NONE
  hi Number       guifg=#e16c58 guibg=NONE ctermfg=167 ctermbg=NONE
  hi Boolean      guifg=#e16c58 guibg=NONE ctermfg=167 ctermbg=NONE

  " Syntax — identifiers
  hi Identifier   guifg=#6ab4c2 guibg=NONE ctermfg=110 ctermbg=NONE
  hi Function     guifg=#38c9a7 guibg=NONE ctermfg=43  ctermbg=NONE

  " Syntax — statements
  hi Statement    guifg=#087fab guibg=NONE ctermfg=31  ctermbg=NONE gui=NONE cterm=NONE
  hi Keyword      guifg=#087fab guibg=NONE ctermfg=31  ctermbg=NONE gui=NONE cterm=NONE
  hi Conditional  guifg=#087fab guibg=NONE ctermfg=31  ctermbg=NONE
  hi Operator     guifg=#c6e0df guibg=NONE ctermfg=152 ctermbg=NONE

  " Syntax — preprocessor / types
  hi PreProc      guifg=#cca2c0 guibg=NONE ctermfg=175 ctermbg=NONE
  hi Include      guifg=#cca2c0 guibg=NONE ctermfg=175 ctermbg=NONE
  hi Type         guifg=#6ab4c2 guibg=NONE ctermfg=110 ctermbg=NONE gui=NONE cterm=NONE
  hi Special      guifg=#ffd2f8 guibg=NONE ctermfg=219 ctermbg=NONE
  hi Delimiter    guifg=#c6e0df guibg=NONE ctermfg=152 ctermbg=NONE
  hi Title        guifg=#38c9a7 guibg=NONE ctermfg=43  ctermbg=NONE gui=bold cterm=bold
  hi Directory    guifg=#6ab4c2 guibg=NONE ctermfg=110 ctermbg=NONE

  " Diagnostics
  hi Error        guifg=#bb2938 guibg=NONE ctermfg=124 ctermbg=NONE
  hi ErrorMsg     guifg=#bb2938 guibg=NONE ctermfg=124 ctermbg=NONE
  hi WarningMsg   guifg=#ddbc44 guibg=NONE ctermfg=179 ctermbg=NONE
  hi Todo         guifg=#ddbc44 guibg=NONE ctermfg=179 ctermbg=NONE gui=bold cterm=bold
  hi MoreMsg      guifg=#38c9a7 guibg=NONE ctermfg=43  ctermbg=NONE
  hi Question     guifg=#38c9a7 guibg=NONE ctermfg=43  ctermbg=NONE

  " UI — cursor / line
  hi CursorLine   guifg=NONE    guibg=#1c2030 ctermfg=NONE ctermbg=234 cterm=NONE
  hi CursorColumn guifg=NONE    guibg=#1c2030 ctermfg=NONE ctermbg=234
  hi LineNr       guifg=#343b51 guibg=NONE    ctermfg=237  ctermbg=NONE
  hi CursorLineNr guifg=#e6cc6f guibg=NONE    ctermfg=186  ctermbg=NONE

  " UI — status / splits
  hi StatusLine   guifg=#c6e0df guibg=#232a3b ctermfg=152 ctermbg=235 gui=NONE cterm=NONE
  hi StatusLineNC guifg=#555e7a guibg=#1c2030 ctermfg=240 ctermbg=234 gui=NONE cterm=NONE
  hi VertSplit    guifg=#232a3b guibg=NONE    ctermfg=235 ctermbg=NONE gui=NONE cterm=NONE

  " UI — tabs
  hi TabLine      guifg=#555e7a guibg=#1c2030 ctermfg=240 ctermbg=234 gui=NONE cterm=NONE
  hi TabLineSel   guifg=#c6e0df guibg=#232a3b ctermfg=152 ctermbg=235 gui=bold cterm=bold
  hi TabLineFill  guifg=NONE    guibg=#0f111a ctermfg=NONE ctermbg=233 gui=NONE cterm=NONE

  " UI — selection / search
  hi Visual       guifg=NONE    guibg=#232a3b ctermfg=NONE ctermbg=235
  hi Search       guifg=#0f111a guibg=#ddbc44 ctermfg=233  ctermbg=179
  hi IncSearch    guifg=#0f111a guibg=#38c9a7 ctermfg=233  ctermbg=43
  hi MatchParen   guifg=#ffd2f8 guibg=#343b51 ctermfg=219  ctermbg=237 gui=bold cterm=bold

  " UI — popup menu
  hi Pmenu        guifg=#c6e0df guibg=#1c2030 ctermfg=152 ctermbg=234
  hi PmenuSel     guifg=#0f111a guibg=#38c9a7 ctermfg=233 ctermbg=43

  " UI — diff
  hi DiffAdd      guifg=NONE    guibg=#1a2e28 ctermfg=NONE ctermbg=236
  hi DiffChange   guifg=NONE    guibg=#1c2535 ctermfg=NONE ctermbg=235
  hi DiffDelete   guifg=#bb2938 guibg=#2a1520 ctermfg=124  ctermbg=234
  hi DiffText     guifg=NONE    guibg=#2a3550 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE

  " UI — folds / signs
  hi Folded       guifg=#555e7a guibg=#1c2030 ctermfg=240 ctermbg=234
  hi FoldColumn   guifg=#343b51 guibg=NONE    ctermfg=237 ctermbg=NONE
  hi SignColumn   guifg=NONE    guibg=NONE    ctermfg=NONE ctermbg=NONE

  " Spelling
  hi SpellBad     guisp=#bb2938 gui=undercurl ctermfg=124 ctermbg=NONE cterm=underline
  hi SpellCap     guisp=#087fab gui=undercurl ctermfg=31  ctermbg=NONE cterm=underline

else
  " ── AlpineDawn (light) ─────────────────────────────────────────────

  " Core
  hi Normal       guifg=#575279 guibg=#faf4ed ctermfg=60  ctermbg=231
  hi Comment      guifg=#9893a5 guibg=NONE    ctermfg=247 ctermbg=NONE gui=italic cterm=italic
  hi NonText      guifg=#9893a5 guibg=NONE    ctermfg=247 ctermbg=NONE
  hi SpecialKey   guifg=#9893a5 guibg=NONE    ctermfg=247 ctermbg=NONE

  " Syntax — literals
  hi Constant     guifg=#ea9d34 guibg=NONE ctermfg=172 ctermbg=NONE
  hi String       guifg=#ea9d34 guibg=NONE ctermfg=172 ctermbg=NONE
  hi Number       guifg=#b4637a guibg=NONE ctermfg=132 ctermbg=NONE
  hi Boolean      guifg=#b4637a guibg=NONE ctermfg=132 ctermbg=NONE

  " Syntax — identifiers
  hi Identifier   guifg=#56949f guibg=NONE ctermfg=73  ctermbg=NONE
  hi Function     guifg=#286983 guibg=NONE ctermfg=24  ctermbg=NONE

  " Syntax — statements
  hi Statement    guifg=#907aa9 guibg=NONE ctermfg=103 ctermbg=NONE gui=NONE cterm=NONE
  hi Keyword      guifg=#907aa9 guibg=NONE ctermfg=103 ctermbg=NONE gui=NONE cterm=NONE
  hi Conditional  guifg=#907aa9 guibg=NONE ctermfg=103 ctermbg=NONE
  hi Operator     guifg=#575279 guibg=NONE ctermfg=60  ctermbg=NONE

  " Syntax — preprocessor / types
  hi PreProc      guifg=#907aa9 guibg=NONE ctermfg=103 ctermbg=NONE
  hi Include      guifg=#907aa9 guibg=NONE ctermfg=103 ctermbg=NONE
  hi Type         guifg=#56949f guibg=NONE ctermfg=73  ctermbg=NONE gui=NONE cterm=NONE
  hi Special      guifg=#d7827e guibg=NONE ctermfg=174 ctermbg=NONE
  hi Delimiter    guifg=#575279 guibg=NONE ctermfg=60  ctermbg=NONE
  hi Title        guifg=#286983 guibg=NONE ctermfg=24  ctermbg=NONE gui=bold cterm=bold
  hi Directory    guifg=#56949f guibg=NONE ctermfg=73  ctermbg=NONE

  " Diagnostics
  hi Error        guifg=#b4637a guibg=NONE ctermfg=132 ctermbg=NONE
  hi ErrorMsg     guifg=#b4637a guibg=NONE ctermfg=132 ctermbg=NONE
  hi WarningMsg   guifg=#ea9d34 guibg=NONE ctermfg=172 ctermbg=NONE
  hi Todo         guifg=#ea9d34 guibg=NONE ctermfg=172 ctermbg=NONE gui=bold cterm=bold
  hi MoreMsg      guifg=#286983 guibg=NONE ctermfg=24  ctermbg=NONE
  hi Question     guifg=#286983 guibg=NONE ctermfg=24  ctermbg=NONE

  " UI — cursor / line
  hi CursorLine   guifg=NONE    guibg=#f2e9e1 ctermfg=NONE ctermbg=230 cterm=NONE
  hi CursorColumn guifg=NONE    guibg=#f2e9e1 ctermfg=NONE ctermbg=230
  hi LineNr       guifg=#9893a5 guibg=NONE    ctermfg=247  ctermbg=NONE
  hi CursorLineNr guifg=#575279 guibg=NONE    ctermfg=60   ctermbg=NONE

  " UI — status / splits
  hi StatusLine   guifg=#575279 guibg=#f2e9e1 ctermfg=60  ctermbg=230 gui=NONE cterm=NONE
  hi StatusLineNC guifg=#9893a5 guibg=#f2e9e1 ctermfg=247 ctermbg=230 gui=NONE cterm=NONE
  hi VertSplit    guifg=#f2e9e1 guibg=NONE    ctermfg=230 ctermbg=NONE gui=NONE cterm=NONE

  " UI — tabs
  hi TabLine      guifg=#9893a5 guibg=#f2e9e1 ctermfg=247 ctermbg=230 gui=NONE cterm=NONE
  hi TabLineSel   guifg=#575279 guibg=#faf4ed ctermfg=60  ctermbg=231 gui=bold cterm=bold
  hi TabLineFill  guifg=NONE    guibg=#f2e9e1 ctermfg=NONE ctermbg=230 gui=NONE cterm=NONE

  " UI — selection / search
  hi Visual       guifg=NONE    guibg=#f2e9e1 ctermfg=NONE ctermbg=230
  hi Search       guifg=#575279 guibg=#f2e9e1 ctermfg=60   ctermbg=230
  hi IncSearch    guifg=#faf4ed guibg=#286983 ctermfg=231  ctermbg=24
  hi MatchParen   guifg=#286983 guibg=#f2e9e1 ctermfg=24   ctermbg=230 gui=bold cterm=bold

  " UI — popup menu
  hi Pmenu        guifg=#575279 guibg=#f2e9e1 ctermfg=60  ctermbg=230
  hi PmenuSel     guifg=#faf4ed guibg=#286983 ctermfg=231 ctermbg=24

  " UI — diff
  hi DiffAdd      guifg=NONE    guibg=#e8f5e9 ctermfg=NONE ctermbg=230
  hi DiffChange   guifg=NONE    guibg=#e8eaf6 ctermfg=NONE ctermbg=230
  hi DiffDelete   guifg=#b4637a guibg=#fce4ec ctermfg=132  ctermbg=230
  hi DiffText     guifg=NONE    guibg=#c5cae9 ctermfg=NONE ctermbg=252 gui=NONE cterm=NONE

  " UI — folds / signs
  hi Folded       guifg=#9893a5 guibg=#f2e9e1 ctermfg=247 ctermbg=230
  hi FoldColumn   guifg=#9893a5 guibg=NONE    ctermfg=247 ctermbg=NONE
  hi SignColumn   guifg=NONE    guibg=NONE    ctermfg=NONE ctermbg=NONE

  " Spelling
  hi SpellBad     guisp=#b4637a gui=undercurl ctermfg=132 ctermbg=NONE cterm=underline
  hi SpellCap     guisp=#286983 gui=undercurl ctermfg=24  ctermbg=NONE cterm=underline

endif
