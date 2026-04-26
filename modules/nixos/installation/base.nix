{
  pkgs,
  config,
  lib,
  inputs,
  system,
  ...
}:
{
  image.modules = {
    isoImage.volumeID = "xinux-${config.isoImage.edition}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
    image.baseName = "xinux-${config.isoImage.edition}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Whitelist wheel users to do anything
  # This is useful for things like pkexec
  #
  # WARNING: this is dangerous for systems
  # outside the installation-cd and shouldn't
  # be used anywhere else.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  security.sudo-rs.enable = true;
  security.sudo.enable = false;

  #> configure: error:
  #     >   *** Cannot build against kernel version 7.0.0.
  #     >  *** The maximum supported kernel version is 6.19.
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_19;

  environment.systemPackages = with pkgs; [
    firefox
    git
    glibcLocales
    # glxinfo
    mesa-demos
    gparted
    nano
    rsync
    vim
    helix
  ];

  i18n.defaultLocale = "uz_UZ.UTF-8";
  i18n.supportedLocales = [ "all" ];

  networking.hostName = "xinux";
  # networking.wireless.enable = false;

  users.users = {
    xinux = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
      ];
      # Allow the graphical user to login without password
      initialHashedPassword = "";
    };
    # Prevent default nixos user form appearing in the login screen
    nixos = {
      isSystemUser = true;
      isNormalUser = lib.mkForce false;
      group = "nixos";
    };
  };
  users.groups.nixos = { };

  system.stateVersion = "26.05";
}
