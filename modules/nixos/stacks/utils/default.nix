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
    environment.systemPackages = [
      pkgs.obsidian
      pkgs.insync
      pkgs.keepassxc
      pkgs.ferdium
      pkgs.vlc
    ];
  };
}
