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