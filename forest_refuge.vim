" save & test ':so %'

" reset highlighting
highlight clear
" set default colors
if exists ("syntax_on")
	syntax reset
endif


" set background variable
set background=dark
" naming color scheme
let colors_name = "forest_refuge"

" set new highlighting
" normal text foreground, background
hi Normal ctermfg=gray guifg=SeaGreen4 guibg=Black

" synthax highlighting (:help group-name)
hi Comment cterm=NONE ctermfg=darkgreen gui=NONE guifg=honeydew
hi Constant cterm=NONE ctermfg=lightgreen gui=NONE guifg=cornsilk4
hi Identifier cterm=NONE ctermfg=darkred gui=NONE guifg=LavenderBlush1
hi Function cterm=bold ctermfg=cyan gui=NONE guifg=DarkSalmon
hi Statement cterm=bold ctermfg=green gui=NONE guifg=chocolate4
hi PreProc cterm=bold ctermfg=yellow gui=NONE guifg=DarkSeaGreen1
hi Type cterm=bold ctermfg=magenta gui=NONE guifg=OldLace
hi Special cterm=bold ctermfg=lightred gui=NONE guifg=brown
hi Delimiter cterm=NONE ctermfg=brown gui=NONE guifg=tomato
hi Error cterm=underline ctermbg=red ctermfg=yellow guifg=orange













