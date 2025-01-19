{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.user;
  defaultIconFileName = "profile.png";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {fileName = defaultIconFileName;};
  };
  propagatedIcon =
    pkgs.runCommandNoCC "propagated-icon"
    {passthru = {fileName = cfg.icon.fileName;};}
    ''
      local target="$out/share/syonekura-icons/user/${cfg.name}"
      mkdir -p "$target"

      cp ${cfg.icon} "$target/${cfg.icon.fileName}"
    '';
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
    icon = lib.mkOption {
      type = package;
      default = defaultIcon;
      description = "User Icon";
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
      propagatedIcon
      fastfetch
    ];

    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name initialPassword;
      description = cfg.fullName;
      home = "/home/${cfg.name}";
      group = "users";
      shell = pkgs.fish;
      uid = 1000;
      extraGroups = cfg.extraGroups;
    };

    # Set user profile pic
    systemd.services.syonekur-user-icon = {
      before = ["display-manager.service"];
      wantedBy = ["display-manager.service"];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
      };

      script = ''
        config_file=/var/lib/AccountsService/users/${cfg.name}
        icon_file=/run/current-system/sw/share/syonekura-icons/user/${cfg.name}/${cfg.icon.fileName}

        if ! [ -d "$(dirname "$config_file")"]; then
          mkdir -p "$(dirname "$config_file")"
        fi

        if ! [ -f "$config_file" ]; then
          echo "[User]
          Session=gnome
          SystemAccount=false
          Icon=$icon_file" > "$config_file"
        else
          icon_config=$(sed -E -n -e "/Icon=.*/p" $config_file)

          if [[ "$icon_config" == "" ]]; then
            echo "Icon=$icon_file" >> $config_file
          else
            sed -E -i -e "s#^Icon=.*$#Icon=$icon_file#" $config_file
          fi
        fi
      '';
    };
  };
}
