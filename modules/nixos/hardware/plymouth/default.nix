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
    videoMode = mkOption {
      type = nullOr str;
      default = null;
      description = "Force a display resolution during boot (e.g. '1920x1080'). Useful when the theme looks too small on high-res displays.";
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
      ] ++ lib.optional (cfg.videoMode != null) "video=${cfg.videoMode}";

      loader.timeout = 0;
    };
  };
}
