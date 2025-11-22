# Ripgrep configuration
set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config

# Useful aliases for ripgrep
if status is-interactive
    abbr -a rgi 'rg --no-ignore' # Search in ignored files too
    abbr -a rgf 'rg --files' # Just list files that would be searched
    abbr -a rgl 'rg -l' # Only show filenames with matches
    abbr -a rgv 'rg --invert-match' # Show lines that don't match

    # Search only in specific file types
    abbr -a rgw 'rg --type=web'
    abbr -a rgc 'rg --type=config'
    abbr -a rgd 'rg --type=docs'
    abbr -a rgp 'rg --type=py'
    abbr -a rgg 'rg --type=go'
    abbr -a rgr 'rg --type=rust'
end
