{
  lib,
  namespace,
  config,
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
  };
}
