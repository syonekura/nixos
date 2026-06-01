{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib;
with lib.types; let
  cfg = config.${namespace}.modules.de.gnome;
  gnomeExtensions = with pkgs.gnomeExtensions; [
    vitals
    bing-wallpaper-changer
  ];
in {
  options.${namespace} = {
    modules.de.gnome.enable = mkOption {
      type = bool;
      default = true;
    };
    gnome.favoriteApps = mkOption {
      type = listOf str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver.enable = true;
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          autoSuspend = false;
          wayland = true;
        };
      };
    };

    environment.systemPackages =
      gnomeExtensions
      ++ [
        pkgs.ffmpeg-headless
        pkgs.ffmpegthumbnailer
        pkgs.file
      ];

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      geary
      gnome-maps
      epiphany
    ];

    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      dconf.settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = builtins.map (extension: extension.extensionUuid) gnomeExtensions;
          favorite-apps = ["org.gnome.Nautilus.desktop"] ++ config.${namespace}.gnome.favoriteApps;
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
        };
        "org/gnome/desktop/sound" = {
          event-sounds = false;
        };
        "org/gnome/mutter" = {
          edge-tiling = true;
          dynamic-workspaces = false;
          workspaces-only-on-primary = false;
        };
        "org/gnome/shell/app-switcher" = {
          current-workspace-only = true;
        };
        "org/gnome/desktop/notifications/application" = {
          "ferdium/enable" = false;
        };
        "org/gnome/desktop/input-sources" = with lib.gvariant; {
          "sources" = [
            (mkTuple ["xkb" "us"])
            (mkTuple ["xkb" "latam"])
          ];
          "mru-sources" = [
            (mkTuple ["xkb" "us"])
          ];
        };
      };
    };
  };
}
