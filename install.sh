#!/bin/bash -e
#
# Chris's dotfile installer, based on Ian's
# https://github.com/statico/dotfiles
#
#   curl https://raw.githubusercontent.com/cbeck527/dotfiles/master/install.sh | sh
#
# or:
#
#   ~/.dotfiles/install.sh
#

basedir=$HOME/.dotfiles

function has() {
    return "$(type $1 >/dev/null)"
}

function note() {
    echo "[32;1m * [0m$*"
}

function warn() {
    echo "[31;1m * [0m$*"
}

function die() {
    warn "$@"
    exit 1
}

function link() {
    src=$1
    dest=$2

    if [ -e "$dest" ]; then
        if [ -L "$dest" ]; then
            # Already symlinked -- I'll assume correctly.
            return
        else
            # Rename files with a ".old" extension.
            warn "$dest file already exists, renaming to $dest.old"
            backup="$dest.old"
            if [ -e "$backup" ]; then
                die "$backup already exists. Aborting."
            fi
            mv -v "$dest" "$backup"
        fi
    fi

    # Update existing or create new symlinks.
    ln -vsf "$src" "$dest"
}

note "Installing dotfiles..."
for path in * ; do
    case $path in
        .|..|.git|README.md|extras|virtualenv|install.sh|localrc*|osxrc)
            continue
            ;;
        *)
            link "$basedir/$path" "$HOME/.$path"
            ;;
    esac
done

if [ "$(uname -s)" == "Darwin" ]; then
  note "Installing macOS specific dotfiles"
  link "$basedir/osxrc" "$HOME/.osxrc"
fi

note "Installing vundle and vim plugins"
if [ ! -d ~/.vim/bundle ]; then
  mkdir -p ~/.vim/bundle
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall


note "Done."
