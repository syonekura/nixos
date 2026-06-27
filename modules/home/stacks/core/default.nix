{namespace, ...}: {
  config.${namespace} = {
    modules = {
      kitty.enable = true;
      alacritty.enable = true;
      zellij.enable = true;
      starship.enable = true;
    };
  };
  config.programs.home-manager.enable = true;
  config.programs.fish.enable = true;
  config.programs.git = {
    enable = true;
    signing.format = "ssh";
    settings = {
      user.name = "Sebastian Yonekura";
      user.email = "sebastian.yonekura@gmail.com";
    };
  };
}
