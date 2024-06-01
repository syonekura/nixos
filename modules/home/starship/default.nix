{
  lib,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.starship;
in {
  options.${namespace}.modules.starship.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
    xdg = {
      enable = true;
      configFile = {"starship.toml".source = ./starship.toml;};
    };
  };
}
