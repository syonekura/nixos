{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.utils;
in {
  options.${namespace}.modules.utils.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.gnome.favoriteApps = ["obsidian.desktop" "ferdium.desktop"];

    environment.systemPackages = [
      pkgs.obsidian
      # pkgs.insync # 3.9.11 fails in auto-patchelf (QtWebEngineProcess.debug); re-enable once fixed upstream
      pkgs.keepassxc
      pkgs.ferdium
      pkgs.spotify
      pkgs.calibre
      pkgs.anki-bin # source build of anki 26.09.4 fails (uv can't fetch hatchling deps offline); switch back to pkgs.anki once fixed
      pkgs.geekbench
      pkgs.libreoffice
      pkgs.ventoy
    ];

    
  };
}
