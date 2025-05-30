# Nixos Setup

Configuration for my Nixos Hosts.

## Install steps

Use a NixOS minimal ISO image live meida.

Allocate enough space for the installation process:

```bash
sudo fallocate -l 60G swapfile
sudo chmod 0600 swapfile
sudo mkswap swapfile
sudo swapon swapfile
sudo mount -o remount,size=30G,noatime /nix/.rw-store
sudo mount -o remount,size=30G,noatime /
```

Then install the SO:

```bash
sudo nix \
    --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko#disko-install -- \
    --flake "github:syonekura/nixos#SalmonTipoJurel" \
    --write-efi-boot-entries \
    --disk one /dev/nvme0n1 \
    --disk two /dev/nvme1n1
```

## Maintenance

Perform changes on this repo and then execute

```bash
sudo nixos-rebuild switch --flake .
```

Upgrade dependencies (flake.lock) with

```bash
nix flake update
```

Clean up unused dependencies and free some space with

```bash
sudo nix-collect-garbage -d
```

### Tweaking Gnome settings

Open a terminal and type

```bash
  dconf watch /
```

  then perform any changes on gnome settings manually, dconf watch will print out the key/value pair for each change. Those can then be added to the gnome nix file

## Features

- [x] VM ready
- [x] Disko
- [x] Gnome
- Core Stack
  + [x] Firefox
  + [x] Fish
  + [x] Kitty
  + [x] Starship
- Photo Stack
  + [x] DarkTable 
  + [x] Rapid Photo Downloader
- Software Development Stack
  + [x] git
  + [x] Helix
  + [x] QEMU
  + [x] [devenv](https://devenv.sh)
  + [x] Jetbrains
     - [x] PyCharm
     - [x] RustRover
  + [x] VS Code (only bc nix support is much more superior compared to JetBrains)
- Gaming Stack
  + [x] Steam
- Utilities Stack
  + [x] Obsidian
  + [x] Borg Backup
  + [x] Insync
  + [x] KeePassXC
  + [x] Ferdium
- Fonts
  + [x] FiraCode Nerd Font

## Dev Setup

Pre-requisites:
- [pre-commit](https://pre-commit.com/)
- [alejandra](https://github.com/kamadorueda/alejandra)
- [just](https://github.com/casey/just)
- [nix](https://nixos.org/)
- [qemu](https://www.qemu.org/)

After installing all pre-requisites, activate precommit by running `pre-commit install`.

## Useful docs / links

The setup is highly influenced by this guide on setting up [NixOS to run on VMs](https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html), with a setup using [Just](https://just.systems/). Other handy docs are listed below:

- [Snowfall Lib](https://snowfall.org/guides/lib/quickstart/)
- [Jake Hamilton's Config](https://github.com/jakehamilton/config/)
- [NixOS package search](https://search.nixos.org/packages)
- [Home Manager Option search](https://home-manager-options.extranix.com/)
- [Install NixOS with disko](https://nixos.asia/en/nixos-install-disko)
