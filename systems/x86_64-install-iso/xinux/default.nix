{ inputs, system, pkgs, config, lib, xinux, ... }:

{
  modules.xinux.xinuxModuleManager.enable = false;
  modules.xinux.nixosConfEditor.enable = false;
}
