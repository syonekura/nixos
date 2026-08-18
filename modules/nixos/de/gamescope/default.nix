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
      # capSysNice must stay OFF: with CAP_SYS_NICE, gamescope launches Steam
      # via bwrap, and since nixpkgs made bwrap non-setuid, bwrap aborts with
      # "Unexpected capabilities but not setuid" — killing the session and
      # bouncing GDM back to the greeter (login loop). See nixpkgs #351516.
      capSysNice = false;
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
