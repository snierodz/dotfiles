#!/usr/bin/env bash
## .bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

#################################################################
# Variables
#################################################################

PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:$HOME/bin:$HOME/go/bin/

################################################################
# Aliases
################################################################

alias ls='ls --color=always'; export ls

function cdiff() {
    diff -u $@ | sed "s/^-/\x1b[31m-/;s/^+/\x1b[32m+/;s/^@/\x1b[34m@/;s/$/\x1b[0m/"
}
alias diff='cdiff'

alias qag='ag --ignore tests --python'

################################################################
# Shell config
################################################################

# Enable sane home/pgup/pgdown/end keys
# http://askubuntu.com/a/206722
stty sane

# Enable UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable X11 forwarding
if [ -z "$DISPLAY" ]; then
    IP_ADDR=$(echo $SSH_CLIENT | awk '{{print $1}}')
    export DISPLAY=$(echo $IP_ADDR:0)
fi

################################################################
# Keyboard bindings
################################################################

#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'

################################################################
# Shell prompt
################################################################

source ~/.bash/vcs-prompt

PS1="\[\e[1;33m\]\u"
PS1+="\[\e[1;37m\] at \[\e[1;31m\]\h"
PS1+="\[\e[1;37m\] in \[\e[1;32m\]\w"
PS1+="\$(prompt_vcs \"\e[1;37m on \e[1;35m\")\n"
PS1+="\[\e[1;37m\]\$ \[\e[0m\]"

PS2="\[\e[1;33m\]→ \[\e[0m\]"

# Show process name in tab title bar
#   source: http://stackoverflow.com/q/10546217

# If this is an xterm set the title to user@host: dir
case "$TERM" in
linux|xterm*|rxvt*)
    # don't print full PWD path or HOSTNAME:
    #   source: https://stackoverflow.com/q/1371261
    #   source: https://stackoverflow.com/q/5268513
    export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}: ${PWD##*/}\007"'
    ;;
screen*)
    # tmux equivalent of the above
    export PROMPT_COMMAND='echo -ne "\033k${HOSTNAME%%.*}: ${PWD##*/}\033\\" '
    ;;
*)
    ;;
esac

###############################################################
# Workarounds
###############################################################

# From https://bbs.archlinux.org/viewtopic.php?id=205961
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"

###############################################################
# Additional settings
###############################################################

if [ -e ~/.bash/internals ]; then
    source ~/.bash/internals
fi

# added by travis gem
[ -f /home/sfinucan/.travis/travis.sh ] && source /home/sfinucan/.travis/travis.sh
