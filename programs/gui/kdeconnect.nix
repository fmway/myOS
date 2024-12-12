{ pkgs, lib, config, ... }:
{
  # Add GSConnect connection configuration.
  enable = true;
  package = lib.mkIf config.services.xserver.desktopManager.gnome.enable pkgs.gnomeExtensions.gsconnect;
}
