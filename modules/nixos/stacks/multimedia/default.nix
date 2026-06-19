{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.multimedia;
in {
  options.${namespace}.modules.multimedia.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.vlc
      pkgs.qbittorrent
      (pkgs.kodi.withPackages (p: [p.joystick]))
    ];
  };
}
