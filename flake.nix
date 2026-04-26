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
      # packages.x86_64-linux = {
      #   default = self.packages.x86_64-linux.iso;
      #   iso = inputs.self.nixosConfigurations.xinux.config.system.build.images.iso-installer;
      # };

      hydraJobs = {
        iso = inputs.self.nixosConfigurations.xinux.config.system.build.images.iso-installer;
      };
    };
}
