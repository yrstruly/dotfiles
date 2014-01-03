#####################################################################
# Ubuntu
#####################################################################

# If not running interactively, don't do anything
#################################################
# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#####################################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Keystrokes
stty -ixoff -ixon

# Global
export PATH=~/bin:~/bash:~/perl:~/python:~/ruby:/opt/bin:/usr/local/bin:$PATH:/usr/local/share/python
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib
export EDITOR=vim
export LANG=en_US.UTF-8

# OS X
export COPYFILE_DISABLE=true

# Jars
for jar in ~/lib/*.jar; do
  export CLASSPATH=$CLASSPATH:$jar
done

# Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias l='ls -alF'
alias ll='ls -l'
alias v='vim '
alias vi2='vi -O2 '
alias hc="history -c"
alias which='type -p'
viw() {
  vim `which "$1"`
}

[ -z "$TMPDIR" ] && TMPDIR=/tmp
alias tmux="tmux -2"
alias tmuxls="ls $TMPDIR/tmux*/"

if [ `uname -s` = 'Darwin' ]; then
  alias ls='ls -G'
  unset LD_LIBRARY_PATH
fi

gd() {
  [ "$1" ] && cd *$1*
}

csbuild() {
  [ $# -eq 0 ] && return

  cmd="find `pwd`"
  for ext in $@; do
    cmd=" $cmd -name '*.$ext' -o"
  done
  echo ${cmd: 0: ${#cmd} - 3}
  eval "${cmd: 0: ${#cmd} - 3}" > cscope.files &&
  cscope -b -q && rm cscope.files
}

gems() {
  for v in 2.0.0 1.8.7 jruby 1.9.3; do
    rvm use $v
    gem $@
  done
}

rakes() {
  for v in 2.0.0 1.8.7 jruby 1.9.3; do
    rvm use $v
    rake $@
  done
}

# Tmux
tx() {
  tmux splitw "$*; echo -n Press enter to finish.; read"
  tmux select-layout tiled
  tmux last-pane
}

alias fopen='fzf | xargs open'

# fd - cd to selected directory
fd() {
  DIR=`find ${1:-*} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf` && cd "$DIR"
}

# fda - including hidden directories
fda() {
  DIR=`find ${1:-*} -type d 2> /dev/null | fzf` && cd "$DIR"
}

# fh - repeat history
fh() {
  eval $(history | fzf --no-sort | sed 's/ *[0-9]* *//')
}

# fkill - kill process
fkill() {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

# Figlet font selector
fgl() {
  cd /usr/local/Cellar/figlet/*/share/figlet/fonts
  BASE=`pwd`
  figlet -f `ls *.flf | sort | fzf` $*
}

# Prompt
if [ ! -e ~/.git-prompt.sh ]; then
  curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi
source ~/.git-prompt.sh
if [ `uname -s` = "Linux" ]; then
  PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
  PROMPT_COMMAND='printf "\[\e[38;5;179m\]%$(($COLUMNS - 4))s\r" $(__git_ps1)'
  PS1="\[\e[38;5;110m\]\u\[\e[38;5;108m\]@\[\e[38;5;186m\]\h\[\e[38;5;95m\]:\[\e[38;5;252m\]\w\[\e[38;5;168m\]> \[\e[0m\]"
fi

EXTRA=$(dirname $(readlink $BASH_SOURCE))/bashrc-extra
if [ -f "$EXTRA" ]; then
  source "$EXTRA"
fi

rvm() {
  unset -f rvm
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
  rvm $@
}

source ~/.fzf.bash

