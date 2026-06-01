{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.photo;
  # Manual backup to external disk
  manual_backup = pkgs.writeShellApplication {
    name = "do-backup";
    runtimeInputs = [
      pkgs.borgbackup
    ];
    text = ''
      # Setting this, so the repo does not need to be given on the commandline:
      export BORG_REPO=/run/media/syonekura/wd_elements/borg

      ${pkgs.borgbackup}/bin/borg create                              \
          --stats                                                     \
          --exclude-caches                                            \
          --progress                                                  \
          ::'{hostname}-{now}'                                        \
          ~/Pictures/                                                 \
          ~/.config/darktable/                                        \
          ~/.config/Rapid\ Photo\ Downloader/                         \
          ~/Videos/

      ${pkgs.borgbackup}/bin/borg prune                       \
      --list                                                  \
      --glob-archives '{hostname}-*'                          \
      --show-rc                                               \
      --keep-daily    7                                       \
      --keep-weekly   4                                       \
      --keep-monthly  6

      ${pkgs.borgbackup}/bin/borg compact
    '';
  };
in {
  options.${namespace}.modules.photo.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.darktable
      pkgs.rapid-photo-downloader
      pkgs.borgbackup
      pkgs.ffmpeg
      pkgs.exiftool
      pkgs.shotcut
    ];

    snowfallorg.users.syonekura.home.config = {
      home.packages = [manual_backup];
    };
  };
}
