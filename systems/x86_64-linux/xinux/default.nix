{ inputs, system, pkgs, config, lib, xinux, ... }:

{
  # Enable debug mode for development purposes
  xinux.debug.enable = true;

  # Don't install Xinux Module Manager by default
  modules.xinux.xinuxModuleManager.enable = false;
}
