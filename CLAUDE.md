# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

Claude Code runs directly on **SalmonTipoJurel** (the dev laptop). Commands like `free -h`, `nixos-rebuild`, etc. execute locally — this is not a remote machine.

## Common Commands

```bash
# Apply config changes to this machine
sudo nixos-rebuild switch --flake .

# Deploy to a remote host (e.g. Atun)
just deploy Atun

# Build and run the test VM (tilapio)
just run

# Update flake.lock
just update

# Garbage collect old generations
sudo nix-collect-garbage -d
```

To capture GNOME setting changes as dconf keys: `dconf watch /`

## Architecture

This is a NixOS flake managed with **[Snowfall Lib](https://snowfall.org/guides/lib/quickstart/)**, which auto-discovers modules and systems from the directory structure — no explicit imports needed.

**Namespace:** `sy` — all custom options live under `sy.*` (e.g. `sy.modules.gaming.enable`).

### Key directories

- `systems/x86_64-linux/<Host>/` — per-machine configuration. Each host has `default.nix` + `hardware-configuration.nix` + disko disk layout.
- `modules/nixos/` — system-level modules (services, hardware, DEs, feature stacks)
- `modules/home/` — home-manager modules (terminal, shell prompt, theme)
- `homes/x86_64-linux/syonekura/` — home-manager config (dconf/GNOME keybindings, XDG MIME, dotfiles)
- `overlays/` — package overrides pulling from `nixpkgs-unstable`

### Hosts

| Host | Role | GPU |
|------|------|-----|
| SalmonTipoJurel | Dev laptop (this machine) | NVIDIA (prime offload) |
| Atun | Living room gaming kiosk | AMD |
| tilapio | Local test VM | QEMU |

### Module pattern

Modules under `modules/nixos/stacks/` group related packages into toggleable feature sets (e.g. `gaming`, `multimedia`, `photo`). Each module exposes a single `enable` boolean under the `sy` namespace:

```nix
options.${namespace}.modules.gaming.enable = lib.mkEnableOption "gaming stack";
```

Enabled per-host in `systems/<Host>/default.nix` via `sy.modules.<name>.enable = true`.

### Home Manager integration

Home Manager is wired in via snowfall — `homes/x86_64-linux/syonekura/` is automatically linked to the `syonekura` user. GNOME settings are managed through `dconf.settings` blocks in that file rather than imperatively.
