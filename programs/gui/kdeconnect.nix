{ pkgs, lib, config, ... }:
{
  # Add GSConnect connection configuration.
  enable = lib.mkDefault true;
  package = lib.mkIf config.services.xserver.desktopManager.gnome.enable pkgs.gnomeExtensions.gsconnect;
}
