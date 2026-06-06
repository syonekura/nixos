# Atun -> Living room gaming desktop (AMD GPU)
{...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.modprobeConfig.enable = true;
  boot.initrd.systemd.enable = true;
  system.stateVersion = "24.05";

  sy.modules = {
    gaming.enable = true;
    multimedia.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # required for Steam/Proton 32-bit games
  };
  services.xserver.videoDrivers = ["amdgpu"];

  imports = [
    ./hardware-configuration.nix
  ];

  # Disko setup
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/nvme0n1"; # use /dev/sda if SATA SSD
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
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
}
