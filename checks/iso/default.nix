# source: https://discourse.nixos.org/t/nixostest-with-flake-configurations/11542/5
{
  inputs,
  pkgs,
  ...
}:
pkgs.testers.runNixOSTest {
  name = "Xinux iso test";

  nodes.machine =
    { ... }:
    {
      imports = with inputs.self; [
        nixosModules.installation
        nix-data.nixosModules.nix-data
        xeonitte.nixosModules.xeonitte
        xinux-modules.nixosModules.gnome
        xinux-modules.nixosModules.branding
        xinux-modules.nixosModules.kernel
        xinux-modules.nixosModules.networking
        xinux-modules.nixosModules.pipewire
        xinux-modules.nixosModules.printing
        xinux-modules.nixosModules.xinux
        xinux-modules.nixosModules.metadata
      ];

      # virtually test nixosConfiguration.
      # I think we do not need this
      # fileSystems."/" = {
      #   # note this should be dynamic based on your disk
      #   device = "/dev/sdb3";
      #   fsType = "ext4";
      # };
    };

  node = {
    # since we are using an overlay, we must make pkgs writable
    pkgsReadOnly = false;

    specialArgs = { inherit inputs; };
  };

  # disable only when working on testScript
  skipTypeCheck = true;

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("uname -a")
    machine.succeed("echo Modules succesfully tested")
  '';
}
