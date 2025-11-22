{
  description = "Chris Becker's nix configuration for his hosts!";

  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Configuration for `nixpkgs`
      nixpkgsDefaults = {
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      # Overlays to expose multiple nixpkgs channels
      overlays = {
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
            };
          };
        };

        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
            };
          };
        };

        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            config = {
              allowUnfree = true;
            };
          };
        };
      };

      # macOS configurations
      darwinConfigurations = {
        # Mininal configurations to bootstrap systems
        bootstrap-x86 = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            { nixpkgs.overlays = builtins.attrValues self.overlays; }
            ./darwin/bootstrap.nix
            { nixpkgs = nixpkgsDefaults; }
          ];
        };
        bootstrap-arm = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = builtins.attrValues self.overlays; }
            ./darwin/bootstrap.nix
            { nixpkgs = nixpkgsDefaults; }
          ];
        };

        beckbook-pro = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs outputs; };
          modules = [
            { nixpkgs.overlays = builtins.attrValues self.overlays; }
            ./machines/beckbook-pro/default.nix
            home-manager.darwinModules.home-manager
          ];
        };
      };

      # TODO: set up linux machines with home-manager

    };
}
