{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.photo;
in {
  options.${namespace}.modules.photo.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.darktable
      pkgs.rapid-photo-downloader
    ];
  };

  # TODO persist RPD config file, DT config file,
  # change library.db / data.db of DT to other location for backup
}
