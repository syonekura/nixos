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
  disko.memSize = 8192;
  disko.devices = {
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };
          };
        };
      };

      two = {
        type = "disk";
        device = "/dev/vdb";
        imageSize = "5G";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid0";
              };
            };
          };
        };
      };
    };

    mdadm = {
      raid0 = {
        type = "mdadm";
        level = 0;
        content = {
          type = "gpt";
          partitions = {
            primary = {
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
}
