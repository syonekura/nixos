# Builds a VM
build:
    nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-23.11 -I nixos-config=./configuration.nix

# executes the VM
run: build clean
    QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-nixos-vm; reset;

# Cleans the VM
clean:
    rm -f nixos.qcow2