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
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

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
        };
      };
    };
  };
}
