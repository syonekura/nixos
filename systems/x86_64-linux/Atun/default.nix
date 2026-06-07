# Atun -> Living room gaming desktop (AMD GPU)
{config, namespace, pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.modprobeConfig.enable = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];
  system.stateVersion = "24.05";

  sy.modules = {
    gaming.enable = true;
    multimedia.enable = true;
  };

  sy.hardware.networking.remoteAccess.enable = true;
  security.sudo.wheelNeedsPassword = false;
  sy.gnome.noOverview = true;
  sy.hardware.plymouth = {
    enable = true;
    theme = "dark_planet";
    themePackage = pkgs.adi1090x-plymouth-themes.override {
      selected_themes = ["dark_planet"];
    };
    videoMode = "1920x1080";
  };
  sy.modules.de.gamescope = {
    enable = true;
    extraGamescopeArgs = ["--adaptive-sync" "--hdr-enabled" "--rt"];
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "5s";
  systemd.network.wait-online.enable = false;
  systemd.user.services.xdg-document-portal.serviceConfig.TimeoutStopSec = "1";

  services.displayManager.autoLogin = {
    enable = true;
    user = config.${namespace}.user.name;
  };

  snowfallorg.users.${config.${namespace}.user.name}.home.config.dconf.settings = {
    "org/gnome/desktop/session" = {
      idle-delay = 0;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };
    "org/gnome/system/location" = {
      enabled = true;
    };
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };
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
