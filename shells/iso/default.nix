{
  lib,
  mkShell,
  stdenv,
  nixd,
  alejandra,
  statix,
  deadnix,
}:

mkShell {
  nativeBuildInputs = [
    nixd
    nixfmt
    statix
    deadnix
  ];
}
