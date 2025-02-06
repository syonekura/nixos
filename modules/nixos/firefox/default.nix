{
  lib,
  namespace,
  config,
  pkgs,
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
            # To add additional extensions, find it on addons.mozilla.org, find
            # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
            # Then, download the XPI by filling it in to the install_url template, unzip it,
            # run `jq .browser_specific_settings.gecko.id manifest.json` or
            # `jq .applications.gecko.id manifest.json` to get the UUID
            # The UUID also can be found at about:debugging#/runtime/this-firefox
            # Good read
            # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/16
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "keepassxc-browser" "keepassxc-browser@keepassxc.org")
            (extension "jetbrains-toolbox" "{bf9e77ee-c405-4dd7-9bed-2f55e448d19a}")
            (extension "catppuccin-mocha-blue" "{88b098c8-19be-421e-8ffa-85ddd1f3f004}")
            (extension "veepn-free-fast-security-vpn" "{94ed9bbf-a1e2-4e58-81ae-cd16dad818d8}")
            (extension "video-downloadhelper" "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}")
          ];
      };
    };
    environment.systemPackages = with pkgs; [
      # Companion app for VideoDownloadHelper
      vdhcoapp
    ];
  };
}
