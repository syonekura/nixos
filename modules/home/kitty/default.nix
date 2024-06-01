{
  lib,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.kitty;
in {
  options.${namespace}.modules.kitty.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      font = {
        size = 16;
        name = "FiraCode Nerd Font";
      };

      settings = {
        tab_bar_min_tabs = 1;
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      };
    };
  };
}
