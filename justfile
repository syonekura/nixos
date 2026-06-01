# Installs SalmonTipoJurel — prompts for password, then runs disko-install
install-salmon disk_one="/dev/nvme0n1" disk_two="/dev/nvme1n1":
    #!/usr/bin/env bash
    set -euo pipefail
    pw_file=$(mktemp)
    trap "rm -f $pw_file" EXIT
    read -s -p "Enter password for syonekura: " pw && echo
    echo "$pw" | nix shell nixpkgs#whois --command mkpasswd -m sha-512 -s > "$pw_file"
    sudo nix \
        --extra-experimental-features 'flakes nix-command' \
        run github:nix-community/disko#disko-install -- \
        --flake "github:syonekura/nixos#SalmonTipoJurel" \
        --write-efi-boot-entries \
        --disk one {{disk_one}} \
        --disk two {{disk_two}} \
        --extra-files "$pw_file":/etc/secrets/syonekura-password

# Installs Atun — prompts for password, then runs disko-install
install-atun disk="/dev/nvme0n1":
    #!/usr/bin/env bash
    set -euo pipefail
    pw_file=$(mktemp)
    trap "rm -f $pw_file" EXIT
    read -s -p "Enter password for syonekura: " pw && echo
    echo "$pw" | nix shell nixpkgs#whois --command mkpasswd -m sha-512 -s > "$pw_file"
    sudo nix \
        --extra-experimental-features 'flakes nix-command' \
        run github:nix-community/disko#disko-install -- \
        --flake "github:syonekura/nixos#Atun" \
        --write-efi-boot-entries \
        --disk one {{disk}} \
        --extra-files "$pw_file":/etc/secrets/syonekura-password

# Builds a VM
build:
    nix --experimental-features 'nix-command flakes' build -L .#nixosConfigurations.tilapio.config.system.build.vmWithDisko

# executes the VM
run: clean build
    QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/disko-vm;

# Cleans the VM
clean:
    rm -f *.qcow2

# Initializes nix repl
repl:
    nix repl --experimental-features 'nix-command flakes'

# Updates lockfile
update:
    nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes
