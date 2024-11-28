{ pkgs, config, lib, ... }:
{
  enable = lib.mkForce (! config.data ? isMinimal || ! config.data.isMinimal);
  nativeMessagingHosts = with pkgs ;[
    firefoxpwa
    gnome-browser-connector
  ];
}
