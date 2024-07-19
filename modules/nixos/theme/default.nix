{
  lib,
  namespace,
  config,
  pkgs,
  ...
}: {
  config = {
    catppuccin = {
      flavor = "mocha";
      accent = "blue";
      enable = true;
    };
    # Makes the theme available in KDE appearance settings. Consider using a different DE?
    # Also Gnome/GTK support is discontinued https://github.com/catppuccin/gtk/issues/262
    environment.systemPackages = lib.mkIf config.${namespace}.modules.kde.enable [
      (pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["blue"];
      })
    ];
    # catppuccin.enable also turns this setting on
    # however this causes to use sddm for login and lightdm for unlocking when using kde
    services.displayManager.sddm.catppuccin.enable = lib.mkIf config.${namespace}.modules.kde.enable false;
  };
}
