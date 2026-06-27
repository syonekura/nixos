{
  lib,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.alacritty;
in {
  options.${namespace}.modules.alacritty.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "FiraCode Nerd Font";
          size = 14;
        };
        window.opacity = 0.75;
        window.startup_mode = "Maximized";
        terminal.shell = {
          program = "zellij";
          args = ["attach" "--create" "main"];
        };
      };
    };
  };
}
