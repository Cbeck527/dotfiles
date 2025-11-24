{
  pkgs,
  ...
}:
let
  # Machine-specific user configuration
  username = "chris";
  userHome = "/Users/chris";

  # Fetch liquid-glass icon assets
  liquidGlassIcons = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/jimeh/emacs-liquid-glass-icons/6e25183fe5a4bdda88458cef44ff7cb0ce678d49/Resources/Assets.car";
    sha256 = "sha256-1XTC872AnytHyfqZB3J805EdwJmRYxvexl1sTnmtZTg=";
  };

  emacs-macport =
    (pkgs.emacs-macport.override {
      withDbus = false;
      withImageMagick = false;
      withNativeCompilation = true;
      withSQLite3 = true;
      withTreeSitter = true;
      withWebP = true;
    }).overrideAttrs
      (old: {
        configureFlags = old.configureFlags ++ [ "--with-mac-metal" ];

        # Set optimized CFLAGS for Apple Silicon
        env = (old.env or { }) // {
          NIX_CFLAGS_COMPILE = "${old.env.NIX_CFLAGS_COMPILE or ""} -O3 -mcpu=native -fobjc-arc";
        };

        postInstall = (old.postInstall or "") + ''
                  # Install liquid-glass-icons
                  if [ -d "$out/Applications/Emacs.app/Contents/Resources" ]; then
                    echo "Installing liquid-glass-icons Assets.car"
                    cp ${liquidGlassIcons} "$out/Applications/Emacs.app/Contents/Resources/Assets.car"

                    # Add CFBundleIconName to Info.plist if not already present
                    plist="$out/Applications/Emacs.app/Contents/Info.plist"
                    if ! grep -q "CFBundleIconName" "$plist"; then
                      echo "Setting CFBundleIconName in Info.plist"
                      ${pkgs.gnused}/bin/sed -i '/<\/dict>/i \
          <key>CFBundleIconName</key>\
          <string>EmacsLG1</string>' "$plist"
                    fi
                  fi
        '';
      });
in
{
  imports = [
    ../common/darwin/defaults.nix
    ../../darwin/bootstrap.nix
  ];

  # Primary user for nix-darwin user-specific settings
  system.primaryUser = username;

  # Pass variables to all modules including home-manager
  _module.args = { inherit username userHome; };

  # system-wide machine-specific nix packages
  environment.systemPackages = [
    emacs-macport
  ];

  # home-manager customizations
  home-manager.users.${username} = {
    programs.atuin = {
      settings = {
        sync_address = "https://shellsync.cmb.software";
      };
    };
    home.packages = with pkgs; [
      pkgs.pkgs-master.claude-code
      ffmpeg

      # language servers
      emacs-lsp-booster
      astro-language-server
      awk-language-server
      basedpyright
      bash-language-server
      buf # protobufs
      dockerfile-language-server
      fish-lsp
      gopls
      nil
      terraform-ls
      vscode-langservers-extracted
      yaml-language-server
    ];
  };

  # Override macOS defaults in ../common/darwin/defaults.nix
  # system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

  # Machine-specific homebrew packages
  homebrew.taps = [
    "facebook/fb"
    "felixkratz/formulae"
    "getsentry/tools"
    "nats-io/nats-tools"
  ];

  homebrew.brews = [
    "flyctl"
  ];

  homebrew.casks = [
    "claude"
    "discord"
    "iina"
    "jdownloader"
    "tidal"
    "transmission"
    "xcodes-app"
    "xld"
    "yaak"
  ];
}
