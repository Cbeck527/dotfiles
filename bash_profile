# Normal ol' aliases
alias reloadprofile='. ~/.bash_profile'

# git aliases
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gs='git status'

# check for whichever version of ls
if ls --color &> /dev/null;
then
  alias ls='ls -lhF --color'
  alias lsa='ls -lahF --color'
else
  alias ls='ls -lhF'
  alias lsa='ls -lahF'
fi

alias grep="grep --color=auto"

# Vars
export CLICOLOR=1
export HISTCONTROL=ignoreboth
export PAGER="less -q"
export HISTFILESIZE=2500
set bell-style none

# Python
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
export PIP_REQUIRE_VIRTUALENV=true

function syspip() {
  PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

export PYTHONDONTWRITEBYTECODE=1

export VIRTUALENVS_HOME=$WORKON_HOME

if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
else
    echo "WARNING: Can't find virtualenvwrapper.sh"
fi


if [ -d "${HOME}/bin" ]; then
  PATH="${HOME}/bin:$PATH"
fi

export PATH=/usr/local/bin:$PATH

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

export GIT_MERGE_AUTOEDIT=0

is_git_repo() {
    $(git rev-parse --is-inside-work-tree &> /dev/null)
}

get_git_branch() {
    local branch_name

    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"

    printf $branch_name
}

# Git status information
function prompt_git() {
    local git_info git_state uc us ut st

    if ! is_git_repo; then
        return 1
    fi

    git_info="[$(get_git_branch)]"

    # Check for uncommitted changes in the index
    if ! $(git diff --quiet --ignore-submodules --cached); then
        git_state="✗"
    fi

    # Check for unstaged changes
    if ! $(git diff-files --quiet --ignore-submodules --); then
        git_state="✗"
    fi

    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        git_state="✗"
    fi


    # Combine the branch name and state information
    if [[ $git_state ]]; then
        git_info="$git_info $git_state"
    fi

    printf " ${git_info}"
}

function venv_prompt() {
  if ! [[ $VIRTUAL_ENV ]]; then
    return 1
  fi
  printf " $(basename $VIRTUAL_ENV)"
}

function gi() { curl http://www.gitignore.io/api/$@ ;}

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

  if [ $(hostname) = "beckbook-pro" ] || [ $(hostname) = "beck-mini" ]; then
    local HOST_PROMPT=""
  else
    local HOST_PROMPT="@\h"
  fi

  export PS1="${GREEN}\u${HOST_PROMPT} ${LIGHT_GRAY}\W${YELLOW}$(venv_prompt)${BLUE}\$(prompt_git)${LIGHT_GRAY} \$ ${NONE}"
  PS2='> '
  PS4='+ '
}

# use .osxrc for settings specific to OS X
if [ -f ~/.osxrc ]; then
    source ~/.osxrc
fi

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
    source ~/.localrc
fi

# Handle resizes gracefully.
shopt -s checkwinsize

reset_prompt
