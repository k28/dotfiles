# .bashrc

# User specific aliases and functions

alias ls='ls -G'
alias ctags='ctags -f .tags'

# cd alias
alias cd..="cd .."
alias cd...="cd ../../"
alias cd.....="cd ../../../"
alias cd.......="cd ../../../../"
alias cd.........="cd ../../../../../"

# spell check for cd command.
shopt -s cdspell

function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# vi mode for command line
set -o vi
# emacs mode for command line
#set -o emacs

export LANG=ja_JP.UTF-8
#export LANG=C # for make and install VIM
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

export LSCOLORS=gxfxcxdxbxegedabagacad

function ut2date {
  /bin/date -u -r $1 +"%Y/%m/%d %H:%M:%S UTC"
  /bin/date -r $1 +"%Y/%m/%d %H:%M:%S"
}
function date2ut {
  /bin/date -j -f "%Y/%m/%d %H:%M:%S" "$1" +%s
}


if [ -f ~/.git-completion.bash ]; then
	source ~/.git-completion.bash
fi

if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

if [ -d ~/bin ]; then
	export PATH=~/bin:$PATH
fi

