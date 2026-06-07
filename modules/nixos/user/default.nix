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
    pkgs.runCommand "propagated-icon"
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
    hashedPasswordFile = lib.mkOption {
      type = str;
      default = "/etc/secrets/syonekura-password";
      description = "Path to file containing the hashed user password";
    };
    extraGroups = lib.mkOption {
      type = listOf str;
      default = ["wheel"];
      description = "Groups that the user belongs to.";
    };
    sshAuthorizedKeys = lib.mkOption {
      type = listOf str;
      default = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRkSrWQ7F0zSpOQ88dkoCzbjCFW+eCag5IuEAFrSp2j8/rZFKWO3J1Vjxy4pzct27dJaaN3eYudQnTH6CUaOhFvkTqXLqbR1p6BnjFHDIO4H8FfqdnCRjEK6/chlOKX9dlrEKILS5g9z0w3NcJxfRx7QwT0uQS6fMyHLIZ+B4xggYh4HNSQcQCh8/EdyNmhTfcqgHhePnrk4V/dvpWiYiT0Mj14y8fdsKUzDm96R2oORbclOsg/IQlsPKbPVYiU7P+0g6b1IAopgnFSldSlFSgX4W7vx2Q52ppxKVsC8IArMhrtKESCbRIvsa8QRP5MqigbNseNtiZkmTrHNiA3b4Rfyms2B+Ve3QXeFdihGiNcHWk9HMzr/g9T6ueAJfsZnPgKNa1QaQVnsnLZ9F2gKrTR2thx+/4QVteDEDxbACtSKZQaZYsAqHc3pod6BPIQAbNo3BvGa/FDyX/C/Ltr/tfofJdRy1YXQ+MBJ/aFX9R++UAT2Hb3Gxa62amUWHzRp+/F3/WFfkXi/eDdZcAvebnR40nPKOBezguK677B6za6u+WP7TCi5HIVIm8snDNicgNU9j4LoyJfg7XgKz5GBFe1vcOBDa0+2rM7kf2DGvQn0ECBltc3wiTwzaUQMU4T9zpPrB51C/evczPLdOG0fHmwmCIWYZLJST8NWDRe6UNnQ== syonekura@SalmonTipoJurel"
      ];
      description = "SSH public keys authorized to log in as this user.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      cowsay
      fortune
      propagatedIcon
      fastfetch
      lshw
    ];

    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name;
      hashedPasswordFile = cfg.hashedPasswordFile;
      description = cfg.fullName;
      home = "/home/${cfg.name}";
      group = "users";
      shell = pkgs.fish;
      uid = 1000;
      extraGroups = cfg.extraGroups;
      openssh.authorizedKeys.keys = cfg.sshAuthorizedKeys;
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
