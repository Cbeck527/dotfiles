#OS X Specific
alias dnscache='dscacheutil -flushcache'
alias apcycle='networksetup -setairportpower en1 off && networksetup -setairportpower en1 on'

alias reloadprofile='. ~/.bash_profile'

alias ls='ls -lh'

function localip {
    ifconfig en1 | grep 'inet[^6]' | awk '{print $2}'
}

#Vars
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export HISTCONTROL=ignoreboth
export PAGER="less -q"
export HISTFILESIZE=2500

set bell-style none

# Python
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
PATH="/usr/local/share/python:$PATH"


if [ -d "${HOME}/bin" ]; then
  PATH="${HOME}/bin:$PATH"
fi

export PATH


if [ -d "${HOME}/bin" ]; then
  PATH="${HOME}/bin:$PATH"
fi

export PATH

if [ -f ~/bin/git-completion.bash ]; then
    . ~/bin/git-completion.bash
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

function reset_prompt {
  local        BLUE="\[\033[0;34m\]"
  local  LIGHT_BLUE="\[\033[1;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local      YELLOW="\[\033[1;33m\]"
  local SOLAR_ORANGE=$(tput setaf 166)
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
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

  export PS1="${LIGHT_GREEN}\u@\h ${LIGHT_GRAY}\W${YELLOW}$(venv_prompt)${LIGHT_BLUE}\$(prompt_git)${LIGHT_GRAY} \$ "
  PS2='> '
  PS4='+ '
}

#export PS1="\W \$"
reset_prompt