{
  pkgs,
  config,
  lib,
  inputs,
  system,
  ...
}: {
  imports = [
    ./base.nix
    ./graphical.nix
  ];

  xinux.debug.enable = true;
}
