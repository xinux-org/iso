{
  mkShell,
  nixd,
  alejandra,
  statix,
  deadnix,
}:

mkShell {
  nativeBuildInputs =
    [
      nixd
      alejandra
      statix
      deadnix
    ];
}
