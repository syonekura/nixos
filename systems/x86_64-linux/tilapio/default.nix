# Tilapio is our test VM
{config, namespace, lib, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.modprobeConfig.enable = true;
  boot.initrd.systemd.enable = true;
  system.stateVersion = "24.05";

  sy.hardware.networking.remoteAccess.enable = true;
  sy.gnome.noOverview = true;
  sy.hardware.plymouth.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = config.${namespace}.user.name;
  };

  virtualisation.vmVariantWithDisko = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      cores = 3;
      graphics = true;
      diskSize = 10000;
      forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
      ];
    };
    users.users.syonekura = {
      initialPassword = "test";
      hashedPasswordFile = lib.mkForce null;
    };
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
