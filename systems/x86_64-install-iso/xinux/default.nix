{ inputs, system, pkgs, config, lib, xinux, ... }:

{
    imports = with inputs; [
        # [HARDWARE_MODULES](https://github.com/NixOS/nixos-hardware/blob/master/flake.nix)
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd
    ];
  modules.xinux.xinuxModuleManager.enable = false;
  modules.xinux.nixosConfEditor.enable = false;
}
