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
      home.config.programs = {
        git = {
          enable = true;
          userEmail = "sebastian.yonekura@gmail.com";
          userName = "Sebastian Yonekura";
        };

        helix = {
          defaultEditor = true;
          enable = true;
        };

        vscode = {
          enable = true;
        };
      };
    };

    environment.systemPackages = [
      pkgs.git
      pkgs.qemu
      pkgs.jetbrains.pycharm-professional
      pkgs.jetbrains.rust-rover
    ];
  };
}
