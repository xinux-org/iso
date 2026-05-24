<div align="center">

# Xinux ISO

Xinux is a NixOS based Linux distribution focused on beginner friendliness and ease of use. This repository contains the configuration used to build the Xinux ISO files.

</div>

## Documentation
This repo uses [nixos-generators](https://github.com/nix-community/nixos-generators) project.

## How to build iso

1. Clone this repository and navigate to the project directory
2. `nixos-rebuild build-image --image-variant iso-installer --flake .#xinux --show-trace`
3. The resulting ISO file will be linked in `result/iso/xinux-<version>.iso`

### Other builds (on NixOS hosts)

```bash
# aarch64-linux
nixos-rebuild build-image --image-variant iso-installer --flake .#xinux-arm --show-trace

# aarch64-linux SD card image
# No installer, the default user/password is `xinux` (change after the first boot)
nixos-rebuild build-image --image-variant sd-card --flake .#xinux-pi --show-trace

# Virtualbox
nixos-rebuild build-image --image-variant virtualbox --flake .#xinux --show-trace

# Vm
nixos-rebuild build-vm --flake .#xinux --show-trace

# VMWARE
nixos-rebuild build-image --image-variant vmware --flake .#xinux --show-trace

# Offline install coming soon...
# nix build .#install-isoCnfigurations.xinux-offline.config.system.build.images.iso
```

### Building on non-NixOS hosts (Ubuntu, Debian, etc.)

`nixos-rebuild` ships only with NixOS. On other Linux distributions, install the Nix package manager and use `nix build` against the same flake attributes.

#### One-time setup

Pick one of the two Nix installers below.

1. Determinate Systems installer (flakes enabled by default):
    ```bash
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```

2. nixos.org installer (flakes must be enabled manually):
    ```bash
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

    # Enable flakes and the nix command
    sudo mkdir -p /etc/nix
    echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
    sudo systemctl restart nix-daemon
    ```

**Optional**: enable aarch64 emulation for cross-arch builds on an x86_64 host

```bash
sudo apt install qemu-user-static binfmt-support
echo 'extra-platforms = aarch64-linux' | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon
```

#### Build commands

```bash
# ISO installer (x86_64)
nix build .#nixosConfigurations.xinux.config.system.build.images.iso-installer --show-trace

# aarch64-linux
nix build .#nixosConfigurations.xinux-arm.config.system.build.images.iso-installer --show-trace

# aarch64-linux SD card image
# No installer, the default user/password is `xinux` (change after the first boot)
nix build .#nixosConfigurations.xinux-pi.config.system.build.images.sd-card --show-trace

# VirtualBox
nix build .#nixosConfigurations.xinux.config.system.build.images.virtualbox --show-trace

# VMware
nix build .#nixosConfigurations.xinux.config.system.build.images.vmware --show-trace
```

## Hardware requirements

> **Note**
> Only 64-bit processors are supported.

### Xinux ISO (x86_64 and AArch64)

|         | Minimum | Recommended
| ------- | ------- | ---
| RAM     | 8 GB    | 16 GB
| Storage | 128 GB  | 256 GB

### Xinux Pi

The kernel-reserved CMA pool (256 MiB, placed inside the low 1 GiB DMA zone) and the GNOME desktop rule out sub-2 GB boards.
Supported Raspberry Pi models:

| Model | RAM
| ----- | ---
| Pi 4  | 2 GB+
| Pi 5  | 4 GB+
| CM4   | 2 GB+

## Development

Add a unique iso name on `system/ARCHITECTURE/HOSTNAME` otherwise the build command gets the first match.
