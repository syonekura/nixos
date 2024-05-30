{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = {
    name = lib.mkOption {
      type = str;
      default = "syonekura";
      description = "the username";
    };
    fullName = lib.mkOption {
      type = str;
      default = "Sebastian Yonekura";
      description = "Full name";
    };
    email = lib.mkOption {
      type = str;
      default = "sebastian.yonekura@gmail.com";
      description = "Email address of the user";
    };
    initialPassword = lib.mkOption {
      type = str;
      default = "password";
      description = "Initial password to use";
    };
    extraGroups = lib.mkOption {
      type = listOf str;
      default = ["wheel"];
      description = "Groups that the user belongs to.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      cowsay
      fortune
      fish
    ];

    programs.fish.enable = true;

    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name initialPassword;
      home = "/home/${cfg.name}";
      group = "users";
      shell = pkgs.fish;
      uid = 1000;
      extraGroups = cfg.extraGroups;
    };
  };
}
