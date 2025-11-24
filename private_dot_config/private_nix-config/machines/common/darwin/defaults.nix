{
  pkgs,
  ...
}:

{
  imports = [
    ./homebrew.nix
    ./home-manager.nix
  ];

  #package config
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      sandbox = "relaxed";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      extra-platforms = aarch64-darwin x86_64-darwin
    '';

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  programs.nix-index.enable = true;

  environment = {
    systemPackages = with pkgs; [
      bashInteractive
      coreutils
      fish
      git
      gnupg
      home-manager
      vim
      zsh
    ];
    shells = with pkgs; [
      fish
      bashInteractive
      zsh
    ];
  };

  programs = {
    fish.enable = true;
    bash.enable = true;
    zsh.enable = true;
  };

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      mru-spaces = false;
      dashboard-in-overlay = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
      FXPreferredViewStyle = "Nlsv";
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };

    universalaccess = {
      closeViewScrollWheelToggle = true;
      closeViewZoomFollowsFocus = true;
    };

    CustomUserPreferences = {
      "com.apple.finder" = {
        FXInfoPanesExpanded = {
          Comments = 1;
          General = 1;
          MetaData = 1;
          Name = 1;
          OpenWith = 1;
          Privileges = 1;
        };
      };
      "com.apple.NetworkBrowser" = {
        BrowseAllInterfaces = 1;
      };
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;
      };
    };
  };

  # Use touch ID for sudo auth
  security.pam.services.sudo_local.touchIdAuth = true;
}
