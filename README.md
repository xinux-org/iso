<div align="center">

# Xinux ISO

Xinux is a NixOS based Linux distribution focused on beginner friendliness and ease of use. This repository contains the configuration used to build the Xinux ISO files.

</div>

## How to build

1. Clone this repository and navigate to the project directory
2. `NIXPKGS_ALLOW_BROKEN=1 nix build .#nixosConfigurations.<arch>.config.system.build.isoImage --impure`
3. The resulting ISO file will be linked in `result/iso/xinux-<version>.iso`
