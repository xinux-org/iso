{
  inputs = {
    # nixpkgs.url = "github:xinux-org/nixpkgs/nixos-unstable";
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-unstable&shallow=1";

    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-modules = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/modules?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xeonitte = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xeonitte?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-data = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/nix-data?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uz-xkb = {
      url = "github:itsbilolbek/uzbek-linux-keyboard";
      flake = false;
    };
  };

  outputs =
    { self, ... }@inputs:
    inputs.xinux-lib.mkFlake {
      inherit inputs;
      channels-config.allowUnfree = true;

      systems.modules.nixos = with inputs; [
        nix-data.nixosModules.nix-data
        xeonitte.nixosModules.xeonitte
        xinux-modules.nixosModules.gnome
        xinux-modules.nixosModules.branding
        xinux-modules.nixosModules.kernel
        xinux-modules.nixosModules.networking
        xinux-modules.nixosModules.pipewire
        xinux-modules.nixosModules.printing
        xinux-modules.nixosModules.xinux
        xinux-modules.nixosModules.metadata
      ];

      src = ./.;
      alias.shells.default = "iso";
      packages = {
        # after writing iso disk, volumeID should be also xinux instead of nixos. See
        # https://github.com/xinux-org/nixpkgs/blob/1167ddc8c033d28b9d07afccba2708af1f73cfc1/nixos/modules/installer/cd-dvd/iso-image.nix#L588
        x86_64-linux.xinux =
          inputs.self.nixosConfigurations.xinux.config.system.build.images.iso-installer.overrideAttrs
            (oldAttrs: {
              postInstall = (oldAttrs.postInstall or "") + ''
                # Rename the resulting .iso file
                mv $out/iso/*.iso $out/iso/xinux-${inputs.self.nixosConfigurations.xinux.config.system.nixos.release}-${inputs.nixpkgs.legacyPackages.x86_64-linux.stdenv.hostPlatform.uname.processor}.iso
              '';
            });
      };

      hydraJobs = inputs.self.packages.x86_64-linux;
    };
}
