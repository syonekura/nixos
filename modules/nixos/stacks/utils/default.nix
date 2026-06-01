{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.utils;
in {
  options.${namespace}.modules.utils.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.gnome.favoriteApps = ["obsidian.desktop" "ferdium.desktop"];

    environment.systemPackages = [
      pkgs.obsidian
      pkgs.insync
      pkgs.keepassxc
      pkgs.ferdium
      pkgs.spotify
      pkgs.calibre
      pkgs.anki
      pkgs.geekbench
      pkgs.libreoffice-fresh
    ];
  };
}
