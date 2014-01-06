if has ('gui_macvim')
	set imdisable
	set antialias
	set lines=90 columns=130
	set guioptions-=T "disable GUI Toolbar
	set showtabline=2
	set guifont=Monaco:h11
	set background=light
	colorscheme desert
endif

if filereadable(expand('~/.gvimrc.local'))
	source ~/.gvimrc.local
endif

