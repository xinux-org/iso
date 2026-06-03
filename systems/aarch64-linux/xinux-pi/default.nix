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

  # Enable auto login
  services.displayManager.autoLogin = {
    enable = true;
    user = "xinux";
  };

  # Enable sudo without password
  security.sudo-rs.wheelNeedsPassword = false;

  # 256 MiB at offset 128 MiB matches Pi OS default
  boot.kernelParams = lib.mkForce [
    "cma=256M@128M"
    "console=tty0"
  ];

  # Force GL renderer
  environment.sessionVariables.GSK_RENDERER = "gl";

  # Load wifi/bluetooth firmware
  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];

  # Enable boot-EEPROM update tools
  environment.systemPackages = [ pkgs.raspberrypi-eeprom ];
}
