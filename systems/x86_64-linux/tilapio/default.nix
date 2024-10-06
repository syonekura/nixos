# Tilapio is our test VM
{...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.modprobeConfig.enable = true;
  system.stateVersion = "24.05";

  virtualisation.vmVariantWithDisko = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
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

  # Disko setup
  disko = {
    devices = {
      disk = {
        one = {
          type = "disk";
          device = "/dev/vda";
          imageSize = "5G";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02";
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}
