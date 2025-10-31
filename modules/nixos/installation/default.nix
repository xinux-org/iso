{ pkgs, config, lib, inputs, system, ... }:
{
  imports = [
    ./base.nix
    ./keyboard.nix
    ./graphical.nix
  ];
}
