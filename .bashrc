# .bashrc

# User specific aliases and functions

alias ls='ls -G'
alias l='ls -G'
alias ctags='ctags -f .tags'

# cd alias
alias cd..="cd .."
alias cd...="cd ../../"
alias cd....="cd ../../../"
alias cd.....="cd ../../../../"
alias cd......="cd ../../../../../"

# spell check for cd command.
shopt -s cdspell

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

# Disallow Python create .pyc file
export PYTHONDONTWRITEBYTECODE=1

# From Ubuntu

if [ -r /etc/debian_version ]; then

    # If not running interactively, don't do anything
    [ -z "$PS1" ] && return

    # don't put duplicate lines or lines starting with space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # If set, the pattern "**" used in a pathname expansion context will
    # match all files and zero or more directories and subdirectories.
    #shopt -s globstar

    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
    xterm-color) color_prompt=yes;;
    esac

    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    #force_color_prompt=yes

    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            # We have color support; assume it's compliant with Ecma-48
            # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
            # a case would tend to support setf rather than setaf.)
                color_prompt=yes
            else
                color_prompt=
        fi
    fi

    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
    esac

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    LS_COLORS="di=36:ex=32:ln=34:bd=33:cd=33:pi=35:so=35"
    LS_COLORS="$LS_COLORS:*.gz=31:*.Z=31:*.lzh=31:*.zip=31:*.bz2=31"
    LS_COLORS="$LS_COLORS:*.tar=31:*.tgz=31"
    LS_COLORS="$LS_COLORS:*.gif=33:*.jpg=33:*.jpeg=33:*.tif=33:*.ps=33"
    LS_COLORS="$LS_COLORS:*.xpm=33:*.xbm=33:*.xwd=33:*.xcf=33"
    LS_COLORS="$LS_COLORS:*.avi=33:*.mov=33:*.mpeg=33:*.mpg=33"
    LS_COLORS="$LS_COLORS:*.mid=33:*.MID=33:*.rcp=33:*.RCP=33:*.mp3=33"
    LS_COLORS="$LS_COLORS:*.mod=33:*.MOD=33:*.au=33:*.aiff=33:*.wav=33"
    LS_COLORS="$LS_COLORS:*.htm=35:*.html=35:*.java=35:*.class=32"
    LS_COLORS="$LS_COLORS:*.c=35:*.h=35:*.C=35:*.c++=35"
    LS_COLORS="$LS_COLORS:*.tex=35:*~=0"
    export LS_COLORS

    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    # Alias definitions.
    # You may want to put all your additions into a separate file like
    # ~/.bash_aliases, instead of adding them here directly.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.

    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi

else # not Debian
    HISTCONTROL=ignoreboth
    HISTSIZE=1000
    HISTFILESIZE=2000
    HISTIGNORE=ls:sl

    # Change man pager to vim
    # Vim open the man page in No Name buffer. It is not possible to grep in the No Name buffer.
    # export MANPAGER="col -b -x|vim -R -c 'set ft=man nolist nomod noma' -"

    # stop Ctrl-S to stty stop
    stty stop undef
fi
# -------------------

# Java home path
if [ -f /usr/libexec/java_home ]; then
    export JAVA_HOME=`/usr/libexec/java_home`
fi

if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

if [ -d ~/bin ]; then
    export PATH=~/bin:$PATH
fi

nXCodeToolChainsPath='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin'
if [ -d $nXCodeToolChainsPath ]; then
    export PATH=$PATH:"$nXCodeToolChainsPath"
fi

nXCodeSDK10_10Path='/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk'
if [ -d $nXCodeSDK10_10Path ]; then
    alias swift='swift -target x86_64-apple-macosx10.9 -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk'
fi


