{ lib, ... }:
{
  options.xinux.iso.live.enable = lib.mkEnableOption "live-installer environment" // {
    default = true;
  };
}
