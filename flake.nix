{
  inputs = {
    # nixpkgs.url = "github:xinux-org/nixpkgs/nixos-unstable";
    nixpkgs.url = "git+https://git.oss.uzinfocom.uz/xinux/nixpkgs?ref=nixos-unstable&shallow=1";

    xinux-lib = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/lib?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-modules = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/modules?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xeonitte = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/xeonitte?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-data = {
      url = "git+https://git.oss.uzinfocom.uz/xinux/nix-data?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uz-xkb = {
      url = "git+https://git.oss.uzinfocom.uz/mirrors/uzbek-linux-keyboard";
      flake = false;
    };
    # Bug reporter for Xinux
    relago.url = "git+https://git.oss.uzinfocom.uz/xinux/relago?ref=main";
  };

  outputs =
    { self, ... }@inputs:
    inputs.xinux-lib.mkFlake {
      inherit inputs;
      channels-config.allowUnfree = true;

      systems.modules.nixos = with inputs; [
        nix-data.nixosModules.nix-data
        xeonitte.nixosModules.xeonitte
        xinux-modules.nixosModules.meta
      ];

      src = ./.;
      alias.shells.default = "iso";
      alias.packages.default = "iso";

      hydraJobs = {
        iso = self.nixosConfigurations.xinux.config.system.build.images.iso-installer;
      };
    };
}
