{
  inputs = {
    nixpkgs.url = "github:xinux-org/nixpkgs/nixos-unstable";

    xinux-modules = {
      url = "github:xinux-org/modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xeonitte = {
      url = "github:xinux-org/xeonitte/";
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
    uz-xkb = {
      url = "github:itsbilolbek/uzbek-linux-keyboard";
      flake = false;
    };
  };

  outputs = inputs:
    let systems = [ "x86_64-linux" "aarch64-linux" ];
    in {
      nixosConfigurations = inputs.nixpkgs.lib.genAttrs systems (system:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowBroken = true;
            };
          };

          modules = [
            { nixpkgs.hostPlatform = system; }

            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

            inputs.nix-data.nixosModules.nix-data
            inputs.xeonitte.nixosModules.xeonitte
            inputs.xinux-modules.nixosModules.gnome
            inputs.xinux-modules.nixosModules.kernel
            inputs.xinux-modules.nixosModules.networking
            inputs.xinux-modules.nixosModules.pipewire
            inputs.xinux-modules.nixosModules.printing
            inputs.xinux-modules.nixosModules.xinux

            inputs.xinux-modules.nixosModules.metadata

            ({ lib, ... }: {
              options.nix = {
                generateNixPathFromInputs = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
                generateRegistryFromInputs = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
                linkInputs = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
              };
            })

          ];
        });
    };
}
