{
  lib,
  namespace,
  config,
  ...
}: {
  options.${namespace}.nix.enable = lib.mkEnableOption "nix";
  config = lib.mkIf config.${namespace}.nix.enable {
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
