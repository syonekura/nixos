{
  lib,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.zellij;
in {
  options.${namespace}.modules.zellij.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      extraConfig = ''
        show_startup_tips false
      '';
    };
  };
}
