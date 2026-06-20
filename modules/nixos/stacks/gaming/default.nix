{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.gaming;
in {
  options.${namespace}.modules.gaming.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.gnome.favoriteApps = ["steam.desktop"];

    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;
    environment.systemPackages = with pkgs; [
      wine
      winetricks
      discord
    ];
  };
}
