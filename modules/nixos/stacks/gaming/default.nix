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
    programs.steam.enable = true;
    environment.systemPackages = with pkgs; [
      wine
      winetricks
      discord
      linuxKernel.packages.linux_6_6.xone
    ];
  };
}
