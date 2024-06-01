{namespace, ...}: {
  config.${namespace} = {
    modules = {
      kitty.enable = true;
      starship.enable = true;
    };
  };
  config.programs.home-manager.enable = true;
}
