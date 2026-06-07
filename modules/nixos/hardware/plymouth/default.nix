{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.types; let
  cfg = config.${namespace}.hardware.plymouth;
in {
  options.${namespace}.hardware.plymouth = {
    enable = mkOption {
      type = bool;
      default = false;
    };
    theme = mkOption {
      type = str;
      default = "circle_hud";
    };
    themePackage = mkOption {
      type = package;
      default = pkgs.adi1090x-plymouth-themes.override {
        selected_themes = ["circle_hud"];
      };
    };
  };

  config = mkIf cfg.enable {
    catppuccin.plymouth.enable = false;

    boot = {
      plymouth = {
        enable = true;
        theme = cfg.theme;
        themePackages = [cfg.themePackage];
      };

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];

      loader.timeout = 0;
    };
  };
}
