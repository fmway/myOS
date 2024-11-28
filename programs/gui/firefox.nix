{ pkgs, lib, config, ... }:
{
  enable = lib.mkForce (! config.data ? isMinimal || ! config.data.isMinimal);
  package = pkgs.firefox;
  nativeMessagingHosts.packages = with pkgs; [
    firefoxpwa
  ];
  wrapperConfig = {
    pipewireSupport = true;
  };
}
