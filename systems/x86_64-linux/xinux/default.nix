{
  inputs,
  system,
  pkgs,
  config,
  lib,
  xinux,
  ...
}:

{
  # Enable debug mode for development purposes
  xinux.debug.enable = true;

  # Don't install some Xinux modules by default
  modules.xinux.xinuxModuleManager.enable = false;
  modules.xinux.relago.enable = false;
}
