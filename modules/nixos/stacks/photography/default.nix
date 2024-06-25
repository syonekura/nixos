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

  snowfallorg.users.syonekura = {
    home = {
      config = {
        # Everything in here is home-manager configuration.
        # TODO persist RPD config file, DT config file,
      };
    };
  };

  # TODO Borg backup needs to cover library.db and data.db of DT for regular backups
}
