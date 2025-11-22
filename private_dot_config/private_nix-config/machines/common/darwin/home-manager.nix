{
  inputs,
  config,
  pkgs,
  lib,
  username,
  userHome,
  ...
}:

{
  # Common user configuration shared across all Darwin machines
  users.users.${username} = {
    home = userHome;
    description = username;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    users.${username} = {
      imports = [
        ../../../modules/gpg.nix
        ../../../modules/git.nix
      ];

      home.stateVersion = "25.05";

      programs.home-manager.enable = true;

      programs.fish = {
        enable = true;
        package = pkgs.pkgs-unstable.fish;
      };

      programs.direnv = {
        enable = true;
        # enableFishIntegration = true;
        config = {
          global = {
            load_dotenv = true;
          };
        };
      };

      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
        flags = [
          "--disable-up-arrow"
        ];
        daemon = {
          enable = true;
        };
        settings = {
          dialect = "us";
          style = "compact";
          filter_mode = "host";
          enter_accept = false;
          secrets_filter = false;
          show_help = false;
          update_check = false;
          show_preview = false;
          show_tabs = false;
        };
      };

      home.packages = with pkgs; [
        # Shell & Terminal
        aspell
        atuin
        bat
        btop
        cowsay
        eza
        fastfetch
        fortune
        fzf
        htop
        neofetch
        pstree
        tmux
        tree
        watch
        zoxide

        # Core Utilities
        coreutils
        curl
        findutils
        gawk
        gnumake
        gnused
        less
        parallel
        procps
        rsync
        wget

        # Search & Text Processing
        dasel
        fd
        jq
        ripgrep
        shellcheck
        silver-searcher
        yq

        # Development Tools
        automake
        chezmoi
        clang-tools
        cmake
        delta
        git
        git-lfs
        gh
        hexyl
        lua-language-server
        nixfmt-rfc-style
        nodejs_24
        stylua
        vim

        # Cloud & Infrastructure
        awscli
        colima
        ctop
        docker
        docker-buildx
        k9s
        kubectl
        kubernetes-helm
        terraform

        # Language-Specific
        go-grip
        golangci-lint
        uv

        # Network Tools
        netcat
        nmap
        socat
        websocat

        # Other
        pinentry_mac
        terminal-notifier
        typst
        zstd
      ];
    };
  };
}
