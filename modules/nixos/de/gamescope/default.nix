{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.types; let
  cfg = config.${namespace}.modules.de.gamescope;
in {
  options.${namespace}.modules.de.gamescope = {
    enable = mkOption {
      type = bool;
      default = false;
      description = "Enable Steam gamescope session as the primary display session.";
    };
    extraGamescopeArgs = mkOption {
      type = listOf str;
      default = [];
      description = "Extra arguments passed to gamescope (e.g. --hdr-enabled --adaptive-sync).";
    };
  };

  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = cfg.extraGamescopeArgs;
      };
    };

    environment.systemPackages = [pkgs.mangohud];

    services.displayManager.defaultSession = "steam";
  };
}
