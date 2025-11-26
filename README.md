# Dotfiles

My personal dotfiles for macOS and Linux boxes, managed with chezmoi, nix,
nix-darwin, nix-homebrew, and home-manager. I'm currently in the middle of
porting everything over to nix but chezmoi is pretty nice for setting up all the
stuff in `XDG_CONFIG_HOME`.

## Install

To install these dotfiles on a new machine, first grab them via chezmoi's handy
bootstrapping:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply cbeck527
```

Install upstream nix from [Determinate Systems](https://determinate.systems/nix-installer/):

``` bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install  --prefer-upstream-nix --diagnostic-endpoint ""
```

Then set everything up!

``` bash
cd ~/.config/nix-config
nix run nix-darwin -- switch --flake .#HOSTNAME
```

