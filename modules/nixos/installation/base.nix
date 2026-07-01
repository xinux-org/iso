{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  # xinux-$EDITION-$RELEASE-$ARCH
  xinuxBaseName = "${config.networking.hostName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
in
{
  image.modules.iso-installer = {
    image.baseName = lib.mkForce xinuxBaseName;
    isoImage.volumeID = lib.mkForce (
      lib.toUpper (
        builtins.replaceStrings [ "-" "." ] [ "_" "_" ]
          "${config.networking.hostName}_${config.system.nixos.release}_${pkgs.stdenv.hostPlatform.uname.processor}"
      )
    );
  };

  image.modules.sd-card = {
    image.baseName = lib.mkForce xinuxBaseName;
    sdImage.rootVolumeLabel = lib.mkForce (
      lib.toUpper (builtins.replaceStrings [ "-" ] [ "_" ] config.networking.hostName)
    );
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Reasonable Defaults
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://cache.xinux.uz/?priority=100"
      ];
      trusted-public-keys = lib.mkBefore [
        "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
      ];
    };
  };

  # Whitelist wheel users to do anything
  # This is useful for things like pkexec
  #
  # WARNING: this is dangerous for systems
  # outside the installation-cd and shouldn't
  # be used anywhere else.
  security.polkit.extraConfig = lib.mkIf config.xinux.iso.live.enable ''
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
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  environment.systemPackages =
    (with pkgs; [
      firefox
      git
      nano
      rsync
      vim
    ])
    ++ lib.optionals config.xinux.iso.live.enable (
      with pkgs;
      [
        glibcLocales
      ]
    )
    ++ lib.optionals config.xinux.debug.enable (
      with pkgs;
      [
        # glxinfo
        helix
        mesa-demos
      ]
    );

  i18n.defaultLocale = "uz_UZ.UTF-8";
  i18n.supportedLocales = lib.mkDefault [ "all" ];

  networking.hostName = lib.mkForce "xinux";
  # networking.wireless.enable = false;

  users.users = {
    xinux = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
      ];
      # Allow the graphical user to login without password (live-installer only)
      initialHashedPassword = lib.mkIf config.xinux.iso.live.enable "";
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
