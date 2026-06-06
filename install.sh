#!/usr/bin/env bash
set -e

# Step 1: Mount USB drive and activate swap
echo "==> Mounting USB drive and activating swap..."
mkdir -p /mnt/usb
mount /dev/sda3 /mnt/usb
swapon /mnt/usb/swapfile

# Step 3: Expand in-memory filesystems
echo "==> Expanding tmpfs size..."
mount -o remount,size=30G,noatime /nix/.rw-store
mount -o remount,size=30G,noatime /

# Step 4: Clone this repo
echo "==> Cloning nixos config..."
git clone https://github.com/syonekura/nixos /tmp/nixos

# Step 5: Generate hardware configuration
echo "==> Generating hardware configuration..."
nixos-generate-config --show-hardware-config \
    > /tmp/nixos/systems/x86_64-linux/Atun/hardware-configuration.nix

# Step 6: Generate password hash
echo "==> Enter password for syonekura user:"
nix --extra-experimental-features 'nix-command flakes' \
    shell nixpkgs#whois \
    --command mkpasswd -m sha-512 \
    > /tmp/sy-pw

# Step 7: Run disko-install
echo "==> Running disko-install..."
nix --extra-experimental-features 'nix-command flakes' \
    run github:nix-community/disko#disko-install -- \
    --flake "/tmp/nixos#Atun" \
    --write-efi-boot-entries \
    --disk one /dev/nvme0n1 \
    --extra-files /tmp/sy-pw:/etc/secrets/syonekura-password
