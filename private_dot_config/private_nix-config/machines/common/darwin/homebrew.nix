{ ... }:

{
  # Common Homebrew packages shared across all Darwin machines
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [ ];

    taps = [
      "hashicorp/tap"
    ];

    casks = [
      # Terminal emulators
      "alacritty"
      "ghostty"
      "kitty"

      # Browsers
      "firefox"
      "google-chrome"
      "orion"

      # Productivity
      "1password-cli"
      "alfred"
      "contexts"
      "rectangle-pro"
      "textexpander"
      "cleanshot"

      # Development
      "sublime-text"
      "bbedit"

      # QuickLook plugins
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "quicklook-json"
      "quicklookase"
      "syntax-highlight"
      "suspicious-package"

      # Utilities
      "bartender"
      "choosy"
      "keka"
      "macupdater"
      "appcleaner"
      "apparency"

      # Communication
      "slack"

      # Other
      "aldente"
      "boltai"
      "wireshark-app"
    ];
  };
}
