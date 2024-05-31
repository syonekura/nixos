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
            # uBlock Origin
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            # KeePassXC Browser
            (extension "keepassxc-browser@keepassxc.org"
              "fcd31e2a-b84f-4b31-bdae-b6b84795576b")
            # JetBrains ToolBox Extension
            (extension "{bf9e77ee-c405-4dd7-9bed-2f55e448d19a}"
              "81db9cd8-94d4-4501-ba59-814fac867326")
            # Catppuccin Mocha - Blue
            (extension "{2adf0361-e6d8-4b74-b3bc-3f450e8ebb69}"
              "2c641677-e3ca-40df-9edb-33e97648d221")
            # VeePN
            (extension "{94ed9bbf-a1e2-4e58-81ae-cd16dad818d8}"
              "0e7c7c74-411c-4f5d-ae83-c6b1cd119bbb")
          ];
      };
      # TODO fixme
      # nativeMessagingHosts = with pkgs; [pkgs.keepassxc];
    };
  };
}
