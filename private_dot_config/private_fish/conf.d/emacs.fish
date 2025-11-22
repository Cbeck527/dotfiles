# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
set -gx GPG_TTY $(tty)

# Try locally compiled emacs installed to system or local Applications folder
fish_add_path -gP ~/Applications/Emacs.app/Contents/MacOS/bin/
fish_add_path -gP /Applications/Emacs.app/Contents/MacOS/bin/
fish_add_path -gP ~/Applications/Emacs.app/Contents/MacOS/
fish_add_path -gP /Applications/Emacs.app/Contents/MacOS/
# ...
# implicit fallback to emacs installed/linked by homebrew

# Doom emacs CLI
fish_add_path -gP $XDG_CONFIG_HOME/emacs/bin
