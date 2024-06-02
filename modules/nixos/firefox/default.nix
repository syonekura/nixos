{
  lib,
  namespace,
  config,
  ...
}:
with lib.types; let
  cfg = config.${namespace}.modules.firefox;
in {
  options.${namespace}.modules.firefox.enable = lib.mkOption {
    type = bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        ExtensionSettings = with builtins; let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
          listToAttrs [
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "keepassxc-browser" "keepassxc-browser@keepassxc.org")
            (extension "jetbrains-toolbox" "{bf9e77ee-c405-4dd7-9bed-2f55e448d19a}")
            (extension "catppuccin-mocha-blue" "{88b098c8-19be-421e-8ffa-85ddd1f3f004}")
            (extension "veepn-free-fast-security-vpn" "{94ed9bbf-a1e2-4e58-81ae-cd16dad818d8}")
          ];
      };
      # TODO fixme
      # nativeMessagingHosts = with pkgs; [pkgs.keepassxc];
    };
  };
}
