<div align="center">

# Xinux ISO

Xinux is a NixOS based Linux distribution focused on beginner friendliness and ease of use. This repository contains the configuration used to build the Xinux ISO files.

</div>

## How to build iso

1. Clone this repository and navigate to the project directory
2. `nix build .#nixosConfigurations.xinux-iso.config.system.build.images.iso`
3. The resulting ISO file will be linked in `result/iso/xinux-<version>.iso`

### Other builds
```bash
# Virtualbox
nix build .#virtualboxConfigurations.xinux-virtualbox.config.system.build.images.virtualbox 

# Vm
nix build .#vmConfigurations.xinux-vm.config.system.build.images.vm

# Offline install coming soon...
nix build .#install-isoCnfigurations.xinux-offline.config.system.build.images.iso
```

## Development

Add unique iso name on `system/ARCHITECTURE/HOSTNAME` othervise it get first match