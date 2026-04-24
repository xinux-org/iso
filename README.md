<div align="center">

# Xinux ISO

Xinux is a NixOS based Linux distribution focused on beginner friendliness and ease of use. This repository contains the configuration used to build the Xinux ISO files.

</div>

## How to build iso

1. Clone this repository and navigate to the project directory
2. `nixos-rebuild build-image --image-variant iso-installer --flake .#xinux --show-trace`
3. The resulting ISO file will be linked in `result/iso/xinux-<version>.iso`

### Other builds
```bash
# aarch64-linux. Not yet sure if it works...
nixos-rebuild build-image --image-variant sd-card --system aarch64-linux --flake .#xinux --show-trace

# Virtualbox
nixos-rebuild build-image --image-variant virtualbox --flake .#xinux --show-trace

# Vm
nixos-rebuild build-vm --flake .#xinux --show-trace

# VMWARE
nixos-rebuild build-image --image-variant vmware --flake .#xinux --show-trace

# Offline install coming soon...
# nix build .#install-isoCnfigurations.xinux-offline.config.system.build.images.iso

```

## Development

Add unique iso name on `system/ARCHITECTURE/HOSTNAME` othervise it get first match
