# Atun -> Living room gaming desktop (AMD GPU)
{config, namespace, pkgs, ...}: let
  pythonWithVdf = pkgs.python3.withPackages (ps: [ps.vdf]);
  addKodiScript = pkgs.writeText "add-kodi-to-steam.py" ''
    import sys, os, vdf

    shortcuts_path = sys.argv[1]
    kodi_exe = "/run/current-system/sw/bin/kodi"
    kodi_name = "Kodi"

    if os.path.exists(shortcuts_path):
        with open(shortcuts_path, "rb") as f:
            data = vdf.binary_loads(f.read())
    else:
        os.makedirs(os.path.dirname(shortcuts_path), exist_ok=True)
        data = {"shortcuts": {}}

    shortcuts = data.get("shortcuts", {})

    for entry in shortcuts.values():
        if entry.get("Exe") == kodi_exe or entry.get("AppName") == kodi_name:
            sys.exit(0)

    next_id = str(len(shortcuts))
    shortcuts[next_id] = {
        "AppName": kodi_name,
        "Exe": kodi_exe,
        "StartDir": "/run/current-system/sw/bin/",
        "icon": "",
        "ShortcutPath": "",
        "LaunchOptions": "",
        "IsHidden": 0,
        "AllowDesktopConfig": 1,
        "AllowOverlay": 1,
        "OpenVR": 0,
        "Devkit": 0,
        "DevkitGameID": "",
        "DevkitOverrideAppID": 0,
        "LastPlayTime": 0,
        "FlatpakAppID": "",
        "tags": {},
    }

    with open(shortcuts_path, "wb") as f:
        f.write(vdf.binary_dumps(data))
  '';
in {
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
    deviceScale = 2;
    transitionDuration = 5;
  };

  # Keep Plymouth visible until gamescope has rendered its first frame.
  # By default plymouth-quit fires the moment display-manager *starts*,
  # leaving a blank gap while Steam Big Picture loads.
  systemd.services."plymouth-quit" = {
    after = ["display-manager.service"];
    requires = ["display-manager.service"];
  };
  sy.modules.de.gamescope = {
    enable = true;
    extraGamescopeArgs = ["--adaptive-sync" "--hdr-enabled" "--rt"];
  };

  systemd.user.services.set-default-volume = {
    description = "Set default audio sink volume to 100%";
    wantedBy = ["default.target"];
    after = ["wireplumber.service"];
    requires = ["wireplumber.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0";
      RemainAfterExit = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/${config.${namespace}.user.name}/Videos 0755 ${config.${namespace}.user.name} users -"
  ];

  snowfallorg.users.${config.${namespace}.user.name}.home.config = {
    home.file.".kodi/userdata/sources.xml".text = ''
      <sources>
        <video>
          <default pathversion="1"></default>
          <source>
            <name>Videos</name>
            <path pathversion="1">/home/${config.${namespace}.user.name}/Videos/</path>
            <allowsharing>true</allowsharing>
          </source>
        </video>
      </sources>
    '';
    dconf.settings = {
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
    home.activation.addKodiToSteam = {
      after = ["writeBoundary"];
      before = [];
      data = ''
        STEAM_USERDATA="$HOME/.local/share/Steam/userdata"
        if [ -d "$STEAM_USERDATA" ]; then
          for USER_DIR in "$STEAM_USERDATA"/*/; do
            [ -d "$USER_DIR" ] || continue
            ${pythonWithVdf}/bin/python3 ${addKodiScript} "$USER_DIR/config/shortcuts.vdf"
          done
        fi
      '';
    };
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "5s";
  systemd.network.wait-online.enable = false;
  systemd.user.services.xdg-document-portal.serviceConfig.TimeoutStopSec = "1";

  services.displayManager.autoLogin = {
    enable = true;
    user = config.${namespace}.user.name;
  };

  # Some Xbox controller firmware versions ship a malformed HID descriptor
  # ("unbalanced collection"), causing hid-generic to reject them with -EINVAL.
  # xpadneo handles Xbox BT controllers specifically and tolerates these quirks.
  hardware.xpadneo.enable = true;

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
