{
  inputs = {
    nixpkgs.url = "github:xinux-org/nixpkgs/nixos-25.05";
    xinux-lib = {
      url = "github:xinux-org/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xinux-modules = {
      url = "github:xinux-org/modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xeonitte = {
      url = "github:xinux-org/xeonitte";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-data = {
      url = "github:xinux-org/nix-data";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.xinux-lib.mkFlake rec {
      inherit inputs;
      channels-config.allowUnfree = true;

      systems.modules.nixos = with inputs; [
        nix-data.nixosModules.nix-data
        xeonitte.nixosModules.xeonitte
        xinux-modules.nixosModules.gnome
        xinux-modules.nixosModules.kernel
        xinux-modules.nixosModules.networking
        xinux-modules.nixosModules.pipewire
        xinux-modules.nixosModules.printing
        xinux-modules.nixosModules.xinux
        xinux-modules.nixosModules.metadata
      ];

      src = ./.;
      alias.shells.default = "iso";
    };
}
