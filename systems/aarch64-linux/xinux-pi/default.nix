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

  # No UEFI, Pi uses rpi-eeprom-update
  services.fwupd.enable = lib.mkForce false;

  # Disable ZFS
  boot.supportedFilesystems.zfs = lib.mkForce false;
  boot.initrd.supportedFilesystems.zfs = lib.mkForce false;

  # Shall we add Russian?
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "uz_UZ.UTF-8/UTF-8"
  ];
  i18n.extraLocales = [ ];

  # We don't need office suite
  modules.xinux.libreofficePack.enable = false;

  # We want only these fonts
  fonts.packages = lib.mkForce (with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    dejavu_fonts
    liberation_ttf
    freefont_ttf
    cantarell-fonts
    font-awesome
    hack-font
  ]);

  # GNOME apps that we don't want
  environment.gnome.excludePackages = [
    #pkgs.decibels             # new music player
    pkgs.evolution
    pkgs.evolutionWithPlugins
    pkgs.gnome-contacts
    pkgs.gnome-maps
    pkgs.gnome-music          # old music player
    pkgs.gnome-weather
    pkgs.simple-scan          # "Document Scanner"
    pkgs.snapshot             # "Camera"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      # espeak-ng is enough
      mbrola = prev.emptyDirectory;
      mbrola-voices = prev.emptyDirectory;
      orca = prev.emptyDirectory;
      speechd = prev.speechd.override { withFlite = false; };
    })
  ];
}
