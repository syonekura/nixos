{pkgs, ...}: {
  config.environment.systemPackages = [
    pkgs.nerd-fonts.fira-code
  ];
}
