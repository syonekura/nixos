{namespace, ...}: {
  config.${namespace} = {
    modules = {
      firefox.enable = true;
      kde.enable = true;
      fish.enable = true;
    };
  };
}
