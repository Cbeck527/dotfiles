{
  pkgs,
  ...
}:
let
  username = "chris";
  userHome = "/Users/chris";
in
{
  imports = [
    ../common/darwin/defaults.nix
    ../../darwin/bootstrap.nix
    ../../modules/emacs.nix
  ];

  custom.emacs.liquidGlassIcons = true;

  system.primaryUser = username;

  _module.args = { inherit username userHome; };

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

      # Meshtastic/SDR
      natscli
      nats-server
      platformio-core
      urh
    ];
  };

  # Override macOS defaults in ../common/darwin/defaults.nix
  # system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

  # Machine-specific homebrew packages
  homebrew.taps = [
    "facebook/fb"
    "getsentry/tools"
  ];

  homebrew.brews = [
    "flyctl"
  ];

  homebrew.casks = [
    "claude"
    "discord"
    "iina"
    "jdownloader"
    "qflipper"
    "tidal"
    "transmission"
    "xcodes-app"
    "xld"
    "yaak"
  ];
}
