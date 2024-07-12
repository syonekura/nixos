{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.software;
in {
  options.${namespace}.modules.software.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    snowfallorg.users.syonekura = {
      home = {
        config = {
          programs.git = {
            enable = true;
            userEmail = "sebastian.yonekura@gmail.com";
            userName = "Sebastian Yonekura";
          };
        };
      };
    };

    environment.systemPackages = [
      pkgs.git
    ];
  };
}
