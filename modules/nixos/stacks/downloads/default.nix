{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.downloads;
in {
  options.${namespace}.modules.downloads.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.qbittorrent
    ];
  };
}
