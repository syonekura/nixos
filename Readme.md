# NixOS Setup

Configuration for my NixOS hosts: **SalmonTipoJurel** (dev laptop), **Atun** (living room kiosk).

## Pending tasks on next reinstall

### SalmonTipoJurel — migrate hibernate to swap partition (Phase 2)

Hibernate currently uses a swapfile with a hardcoded `resume_offset`. On the next reinstall, switch to a dedicated swap partition which is offset-free and reinstall-safe. In `systems/x86_64-linux/SalmonTipoJurel/default.nix`:

1. Delete the **PHASE 1** block (swapDevices, boot.resumeDevice, boot.kernelParams)
2. Uncomment `boot.resumeDevice` from the **PHASE 2** block
3. In the disko section, shrink `primary` size to `-${toString swapMB}M` (currently `-33377M`) and uncomment the `swap` partition

## Install steps

Use a NixOS minimal ISO image live media.

Allocate enough space for the installation process:

```bash
sudo fallocate -l 60G swapfile
sudo chmod 0600 swapfile
sudo mkswap swapfile
sudo swapon swapfile
sudo mount -o remount,size=30G,noatime /nix/.rw-store
sudo mount -o remount,size=30G,noatime /
```

### SalmonTipoJurel

Dual NVMe RAID 0. Connect to WiFi first (`nmtui`), then:

```bash
nix shell nixpkgs#whois --command mkpasswd -m sha-512 | sudo tee /tmp/sy-pw > /dev/null && \
sudo nix --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko#disko-install -- \
    --flake "github:syonekura/nixos#SalmonTipoJurel" \
    --write-efi-boot-entries \
    --disk one /dev/nvme0n1 \
    --disk two /dev/nvme1n1 \
    --extra-files /tmp/sy-pw:/etc/secrets/syonekura-password
```

### Atun

Boot the NixOS minimal ISO, connect to WiFi (`nmtui`), then run:

```bash
sudo bash <(curl -s https://raw.githubusercontent.com/syonekura/nixos/main/install.sh)
```

The script will:

1. Mount `/dev/sda3` as swap storage and activate `/mnt/usb/swapfile`
2. Remount `/nix/.rw-store` and `/` with `size=30G,noatime` to give the installer enough headroom
3. Clone this repo to `/tmp/nixos`
4. Generate `hardware-configuration.nix` for this machine and write it into the cloned repo
5. Prompt for the `syonekura` user password and hash it to `/tmp/sy-pw`
6. Run `disko-install` against `/dev/nvme0n1` using the `Atun` flake output

> Note: replace `/dev/nvme0n1` with `/dev/sda` inside the script if Atun has a SATA SSD.

**Manual install** (if the script is unavailable):

```bash
nix shell nixpkgs#whois --command mkpasswd -m sha-512 | sudo tee /tmp/sy-pw > /dev/null && \
sudo nix --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko#disko-install -- \
    --flake "github:syonekura/nixos#Atun" \
    --write-efi-boot-entries \
    --disk one /dev/nvme0n1 \
    --extra-files /tmp/sy-pw:/etc/secrets/syonekura-password
```

## Maintenance

Apply config changes:

```bash
sudo nixos-rebuild switch --flake .
```

Deploy to a remote host (e.g. Atun):

```bash
just deploy Atun
```

Update flake inputs:

```bash
just update
```

Garbage collect old generations:

```bash
sudo nix-collect-garbage -d
```

Clean up boot entries:

```bash
sudo /run/current-system/bin/switch-to-configuration boot
sudo nix-collect-garbage -d
```

### Tweaking GNOME settings

```bash
dconf watch /
```

Make changes in GNOME settings — dconf watch prints the key/value pairs which can then be added to `homes/x86_64-linux/syonekura/default.nix`.

### Testing with the local VM

```bash
just run   # builds tilapio VM and launches it
just ssh-vm  # SSH into the running VM
```

## Useful docs / links

- [Snowfall Lib](https://snowfall.org/guides/lib/quickstart/)
- [Jake Hamilton's Config](https://github.com/jakehamilton/config/)
- [NixOS package search](https://search.nixos.org/packages)
- [Home Manager Option search](https://home-manager-options.extranix.com/)
- [Install NixOS with disko](https://nixos.asia/en/nixos-install-disko)
- [NixOS on VMs guide](https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html)
