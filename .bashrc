# .bashrc

# User specific aliases and functions

alias ls='ls -G'
alias ctags='ctags -f .tags'

# vi mode for command line
set -o vi
# emacs mode for command line
#set -o emacs

export LANG=ja_JP.UTF-8
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

export LSCOLORS=gxfxcxdxbxegedabagacad

if [ -f ~/.git-completion.bash ]; then
	source ~/.git-completion.bash
fi

if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

