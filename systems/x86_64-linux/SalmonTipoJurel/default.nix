# SalmonTipoJurel -> Dev Laptop
{...}: let
  ramMB = 31788;
  swapMB = ramMB + (ramMB / 20); # 105%
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.modprobeConfig.enable = true;
  system.stateVersion = "24.05";

  sy.modules = {
    photo.enable = true;
    software.enable = true;
    utils.enable = true;
    multimedia.enable = true;
    downloads.enable = true;
    gaming.enable = true;

    # TODO enable options
    #    hardware = {
    #        networking.enable = true;
    #    };
  };

  hardware.bluetooth = {
    enable = true;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  boot.swraid.mdadmConf = "MAILADDR root";

  boot.blacklistedKernelModules = ["serial8250"];

  # ── PHASE 1 (swapfile, current) ─────────────────────────────────────────────
  # On next reinstall: delete this block and uncomment PHASE 2 below.
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 33000; # frozen — changing this recreates the swapfile and invalidates resume_offset
  }];
  boot.resumeDevice = "/dev/disk/by-uuid/91f30a25-6e48-4e8b-bc26-c4e74668d7b9";
  boot.kernelParams = ["resume_offset=161798144"];
  # ────────────────────────────────────────────────────────────────────────────

  # ── PHASE 2 (swap partition, uncomment on next reinstall) ───────────────────
  # boot.resumeDevice = "/dev/disk/by-label/swap";
  # ────────────────────────────────────────────────────────────────────────────

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # TODO move to general / gaming module (?)
    ./auto-offload.nix
  ];

  # Disko setup
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/nvme0n1";
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
        device = "/dev/nvme1n1";
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
              # PHASE 2: leave room for the swap partition by replacing 100% with a fixed size
              # size = "-${toString swapMB}M";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            # ── PHASE 2 (uncomment on next reinstall, delete PHASE 1 block above) ──
            # swap = {
            #   size = "${toString swapMB}M";
            #   content = {
            #     type = "swap";
            #     extraArgs = ["-L" "swap"];
            #   };
            # };
            # ────────────────────────────────────────────────────────────────────────
          };
        };
      };
    };
  };
}
