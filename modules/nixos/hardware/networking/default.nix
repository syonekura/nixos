{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.networking;
in
{
# TODO add options
#  options.${namespace}.hardware.networking = with types; {
#    enable = mkOption {
#    type = bool;
#    default = false;
#  };
#    hosts = mkOpt attrs { } (mdDoc "An attribute set to merge with `networking.hosts`");
#  };

#  config = mkIf cfg.enable {
   config = {
    sy.user.extraGroups = [ "networkmanager" ];

    networking = {
      hosts = {
        "127.0.0.1" = [ "local.test" ] ++ (cfg.hosts."127.0.0.1" or [ ]);
      } // cfg.hosts;

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