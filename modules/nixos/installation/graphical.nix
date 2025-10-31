{
  pkgs,
  lib,
  config,
  inputs,
  system,
  ...
}: let
  xeonitte-autostart = pkgs.makeAutostartItem {
    name = "org.xinux.Xeonitte";
    package = inputs.xeonitte.packages.${system}.xeonitte;
  };
in {
  xeonitte.enable = true;

  services.desktopManager.gnome = {
    # Add Firefox and other tools useful for installation to the launcher
    favoriteAppsOverride = ''
      [org.gnome.shell]
      favorite-apps=[ 'org.gnome.Epiphany.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'org.xinux.NixSoftwareCenter.desktop', 'gparted.desktop', 'org.xinux.Xeonitte.desktop' ]
    '';

    # Override GNOME defaults to disable GNOME tour and disable suspend
    extraGSettingsOverrides = ''
      [org.gnome.shell]
      welcome-dialog-last-shown-version='9999999999'
      [org.gnome.desktop.session]
      idle-delay=0
      [org.gnome.settings-daemon.plugins.power]
      sleep-inactive-ac-type='nothing'
      sleep-inactive-battery-type='nothing'
    '';

    extraGSettingsOverridePackages = [pkgs.gnome-settings-daemon];
  };

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "xinux";
    };
  };

  services.displayManager = {
    gdm = {
      enable = true;
      # autoSuspend makes the machine automatically suspend after inactivity.
      # It's possible someone could/try to ssh'd into the machine and obviously
      # have issues because it's inactive.
      # See:
      # * https://github.com/NixOS/nixpkgs/pull/63790
      # * https://gitlab.gnome.org/GNOME/gnome-control-center/issues/22
      autoSuspend = false;
    };
  };

  # VM guest additions to improve host-guest interaction
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.vmware.guest.enable = pkgs.stdenv.hostPlatform.isx86;
  virtualisation.hypervGuest.enable = true;
  services.xe-guest-utilities.enable = pkgs.stdenv.hostPlatform.isx86;
  # The VirtualBox guest additions rely on an out-of-tree kernel module
  # which lags behind kernel releases, potentially causing broken builds.
  virtualisation.virtualbox.guest.enable = false;

  # Enable plymouth
  boot.plymouth.enable = true;

  programs.nix-data = {
    enable = true;
    systemconfig = null;
    flake = null;
    flakearg = null;
  };
}
