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

  # Don't install Xinux Module Manager by default
  modules.xinux.xinuxModuleManager.enable = false;

  # Boot-and-use system (no live installer)
  xinux.iso.live.enable = false;

  # First-boot password
  users.users.xinux.initialPassword = "xinux";

  # 256 MiB at offset 128 MiB matches Pi OS default
  boot.kernelParams = [
    "cma=256M@128M"
  ];
}
