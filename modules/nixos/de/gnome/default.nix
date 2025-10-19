{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.de.gnome;
  gnomeExtensions = with pkgs.gnomeExtensions; [
    vitals
    bing-wallpaper-changer
  ];
in {
  options.${namespace}.modules.de.gnome.enable = lib.mkOption {
    type = bool;
    default = true;
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Enable the X11 windowing system.
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

    environment.systemPackages = gnomeExtensions;

    # Remove GNOME bloatware
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
          favorite-apps = with lib.lists;
            [
              "org.gnome.Nautilus.desktop"
            ]
            ++ optional config.${namespace}.modules.firefox.enable "firefox.desktop"
            ++ optional config.${namespace}.modules.utils.enable "obsidian.desktop"
            ++ optional config.${namespace}.modules.utils.enable "ferdium.desktop"
            ++ optional config.${namespace}.modules.software.enable "code.desktop"
            ++ optional config.${namespace}.modules.gaming.enable "steam.desktop";
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
        # Enable or disable pop-up notifications here
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
