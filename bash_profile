# general
export TERM=xterm-256color
export CLICOLOR=1
export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTFILESIZE=2500
export PAGER="less -q"
set bell-style none

# bash history
export HISTFILESIZE=99999999
export HISTSIZE=99999999
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="history -a;history -c;history -r;echo -n -e '\033k\033\\'"
shopt -s histappend

# agnostic aliases
alias reloadprofile='. ~/.bash_profile'
alias incognito='unset HISTFILE'

# git
export GIT_MERGE_AUTOEDIT=0
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gs='git status'
alias gcd='cd $(git rev-parse --show-toplevel)'

# coreutils colors
alias grep="grep --color=auto"
if ls --color &> /dev/null;
then
  alias ls='ls -lhF --color'
  alias lsa='ls -lahF --color'
else
  alias ls='ls -lhF'
  alias lsa='ls -lahF'
fi

# color man pages
# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# Python
export PYTHONDONTWRITEBYTECODE=1

function venv_prompt() {
  if ! [[ $VIRTUAL_ENV ]]; then
    return 1
  fi
  printf " %s" "$(basename $VIRTUAL_ENV)"
}

# marks
export MARKPATH=$HOME/.marks
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
function marks {
    \/bin/ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}
_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l | awk -F '/' '{print $NF}')
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}
complete -F _completemarks jump unmark

#
# Conditional includes
#

# aws
if type aws > /dev/null 2>&1; then
  complete -C aws_completer aws
fi

# handy fabric completion
if [ -f ~/.fabricrc ]; then
    source ~/.fabricrc
fi

# use .osxrc for settings specific to OS X
if [ -f ~/.osxrc ]; then
    source ~/.osxrc
fi

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
    source ~/.localrc
fi

# use .secretsrc for API keys and sensitive info
if [ -f ~/.secretsrc ]; then
    source ~/.secretsrc
fi

# add FZF (fuzzy finder) if present, and setup commands
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='
    (git ls-tree -r --name-only HEAD ||
    ag -g "") 2> /dev/null'
export FZF_DEFAULT_OPTS="
    --no-height
    --color fg:-1,bg:-1,hl:136,fg+:254,bg+:-1,hl+:136
    --color info:136,prompt:136,pointer:230,marker:230,spinner:136
"
# Handle resizes gracefully.
shopt -s checkwinsize

# export PATH
PATH=/usr/local/bin:$PATH
if [ -d "${HOME}/.bin" ]; then
    PATH="${HOME}/.bin:$PATH"
fi
export PATH=$PATH

# prompt
function reset_prompt {

  local NONE="\[\e[0m\]"    # unsets color to term's fg color

  local        BLUE="\[\033[0;34m\]"
  local  LIGHT_BLUE="\[\033[1;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local      YELLOW="\[\033[0;33m\]"
  local      TEAL="\[\033[0;36m\]"

  BOLD=$(tput bold)
  RESET=$(tput sgr0)
  SOLAR_YELLOW=$(tput setaf 136)
  SOLAR_ORANGE=$(tput setaf 166)
  SOLAR_RED=$(tput setaf 124)
  SOLAR_MAGENTA=$(tput setaf 125)
  SOLAR_VIOLET=$(tput setaf 61)
  SOLAR_BLUE=$(tput setaf 33)
  SOLAR_CYAN=$(tput setaf 37)
  SOLAR_GREEN=$(tput setaf 64)
  SOLAR_WHITE=$(tput setaf 254)

  if [ "$(hostname)" = "beckbook" ] || [ "$(hostname)" = "beckbook-pro" ] || [ "$(hostname)" = "beck-5k" ]; then
    local HOST_PROMPT=""
  else
    local HOST_PROMPT='@\h'
  fi

export PS1="${GREEN}\u${HOST_PROMPT} ${LIGHT_GRAY}\W${YELLOW}$(venv_prompt)${BLUE}\$(vcprompt -f ' [%b${RED}%u%m${BLUE}]')${LIGHT_GRAY} \$ ${NONE}"
export PS2='> '
export PS4='+ '
}

reset_prompt

# Local Variables:
# mode: shell-script
# End:
