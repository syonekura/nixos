{...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.05";

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = true;
      diskSize = 10000;
    };
  };

  sy.modules = {
    photo.enable = true;
    software.enable = true;
    utils.enable = true;
    gaming.enable = true;
  };
}
