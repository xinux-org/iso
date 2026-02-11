{ inputs, system, pkgs, config, lib, xinux, ... }:

{
  modules.xinux.debug = true;
  modules.xinux.xinuxModuleManager.enable = false;
  modules.xinux.nixosConfEditor.enable = false;
}
