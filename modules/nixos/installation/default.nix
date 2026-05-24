{
  pkgs,
  config,
  lib,
  inputs,
  system,
  ...
}:
{
  imports = [
    ../iso-options.nix
    ./base.nix
    ./graphical.nix
  ];

  xinux.debug.enable = true;
}
