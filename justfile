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

# Deploy to a remote NixOS host over SSH: just deploy Atun
deploy host:
    nixos-rebuild switch --flake .#{{host}} --target-host {{host}}.local --use-remote-sudo

# SSH into the local test VM (run 'just run' first)
ssh-vm:
    ssh -p 2222 syonekura@localhost
