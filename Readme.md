# Nixos Setup

Configuration for my Nixos Hosts.

## Features

- [x] VM ready
- [x] KDE
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
  + [ ] mise
  + [x] Jetbrains
     - [x] PyCharm
     - [x] RustRover
  + [x] VS Code (only bc nix support is much more superior compared to JetBrains)
- Gaming Stack
  + [ ] Steam
- Utilities Stack
  + [ ] Obsidian
  + [x] Borg Backup
  + [ ] Insync
  + [ ] KeePassXC
  + [ ] Ferdium
- Fonts
  + [x] FiraCode Nerd Font

## Setup

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
