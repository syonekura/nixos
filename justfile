# Builds a VM
build:
    nix --experimental-features 'nix-command flakes' build .#nixosConfigurations.tilapio.config.system.build.vm

# executes the VM
run: build clean
    QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-tilapio-vm;

# Cleans the VM
clean:
    rm -f nixos.qcow2

# Initializes nix repl
repl:
    nix repl --experimental-features 'nix-command flakes'
