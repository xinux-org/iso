{
  lib,
  config,
  ...
}:
{
  options.xinux.debug = {
    enable = lib.mkEnableOption "Enable debug mode for internal remote development.";
  };

  config = lib.mkIf config.xinux.debug.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };
  };
}
