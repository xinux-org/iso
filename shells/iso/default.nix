{
  lib,
  mkShell,
  stdenv,
  nixd,
  nixfmt,
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
