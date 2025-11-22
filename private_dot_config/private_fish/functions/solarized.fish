function solarized --description "Switch between solarized-dark and solarized-light"
    if test (count $argv) -ne 1
        echo "Usage: solarized <light|dark>"
        return 1
    end
    if test $argv[1] != light -a $argv[1] != dark
        echo "Invalid argument. Please specify either 'light' or 'dark'."
        return 1
    end
    set -l theme solarized-$argv[1]

    # update alacritty
    sed -i "s/\(~\/\.config\/alacritty\/themes\/\).*/\1$theme.toml\",/" ~/.config/alacritty/alacritty.toml

    printf "Set theme to %b$theme\n" (set_color brwhite)
end
