{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.types; let
  cfg = config.${namespace}.hardware.networking;
in {
  options.${namespace}.hardware.networking.enable = mkOption {
    type = bool;
    default = true;
  };

  config = mkIf cfg.enable {
    sy.user.extraGroups = ["networkmanager"];

    networking = {
      networkmanager = {
        enable = true;
        dhcp = "internal";
      };
    };

    # Fixes an issue that normally causes nixos-rebuild to fail.
    # https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
