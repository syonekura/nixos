{
  lib,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.de.gnome;
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

    # Remove GNOME bloatware
    services.gnome.core-utilities.enable = false;
  };
}
