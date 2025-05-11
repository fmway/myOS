{ pkgs, config, lib, ... }:
{
  enable = ! config.data.isMinimal or false;
  nativeMessagingHosts = with pkgs ;[
    firefoxpwa
    gnome-browser-connector
  ];
}
