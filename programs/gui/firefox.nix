{ pkgs, lib, config, ... }:
{
  enable = lib.mkForce (! (config.data.isMinimal or false));
  package = pkgs.firefox;
  nativeMessagingHosts.packages = with pkgs; [
    firefoxpwa
  ];
  wrapperConfig = {
    pipewireSupport = true;
  };
}
