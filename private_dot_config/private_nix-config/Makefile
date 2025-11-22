IMPURE ?= false

UNAME := $(shell uname)
UNAME_P := $(shell uname -p)
HOSTNAME := $(shell hostname)

ifeq ($(UNAME_P),arm)
BOOTSTRAP := bootstrap-arm
else
BOOTSTRAP := bootstrap-x86
endif

# Channels
NIX_CHANNELS := nixpkgs-master nixpkgs-stable nixpkgs-unstable nixos-stable
HOME_CHANNELS := home-manager
OSX_CHANNELS := nix-darwin

impure := $(if $(filter $(IMPURE),true),--impure,)


ifeq ($(UNAME), Darwin) # darwin targets
all: switch

switch: result/sw/bin/darwin-rebuild
	TERM=xterm ./result/sw/bin/darwin-rebuild switch ${impure} --verbose --flake ".#$(HOSTNAME)" --fallback --option sandbox false

switch.bootstrap: result/sw/bin/darwin-rebuild
	./result/sw/bin/darwin-rebuild switch ${impure} --verbose --flake ".#$(BOOTSTRAP)"
	TERM=xterm ./result/sw/bin/darwin-rebuild switch ${impure} --verbose --flake ".#$(HOSTNAME)"

result/sw/bin/darwin-rebuild:
	nix --experimental-features 'flakes nix-command' build ".#darwinConfigurations.$(BOOTSTRAP).system" --option sandbox false


endif # end osx


# TODO: set up linux machines with home-manager
ifeq ($(UNAME), Linux) # linux targets

all:
	@echo "switch.linux"

switch.linux:
	nix build .#homeConfigurations.linux.activationPackage
	./result/activate switch ${impure} --verbose; ./result/activate

endif # end linux

clean:
	./result/sw/bin/nix-collect-garbage

fclean:
	@echo "/!\ require to be root"
	sudo ./result/sw/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations old
	./result/sw/bin/nix-collect-garbage -d


update: update.nix update.osx update.home
update.nix:; nix flake lock $(addprefix --update-input , $(NIX_CHANNELS))
update.osx:; nix flake lock $(addprefix --update-input , $(OSX_CHANNELS))
update.home:; nix flake lock $(addprefix --update-input , $(HOME_CHANNELS))
