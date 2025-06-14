{ pkgs, config, lib, ... }:
{
  enable = lib.mkDefault true;
  nativeMessagingHosts = with pkgs ;[
    firefoxpwa
    gnome-browser-connector
  ];
}
