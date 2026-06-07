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
  options.${namespace}.hardware.networking = {
    enable = mkOption {
      type = bool;
      default = true;
    };
    remoteAccess.enable = mkOption {
      type = bool;
      default = false;
      description = "Enable SSH server and mDNS for remote access and deployment.";
    };
  };

  config = mkIf cfg.enable {
    sy.user.extraGroups = ["networkmanager"];

    networking.networkmanager = {
      enable = true;
      dhcp = "internal";
    };

    # Fixes an issue that normally causes nixos-rebuild to fail.
    # https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = false;

    # Enable .local resolution on all machines so they can discover mDNS hosts
    services.avahi.nssmdns4 = true;
    services.avahi.enable = mkIf cfg.remoteAccess.enable true;
    services.avahi.publish = mkIf cfg.remoteAccess.enable {
      enable = true;
      addresses = true;
      domain = true;
    };
    services.openssh = mkIf cfg.remoteAccess.enable {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };
}
