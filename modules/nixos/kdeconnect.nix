{ pkgs, lib, config, ... }:
{
  programs.kdeconnect = {
    enable = lib.mkDefault true;

    # add gsconnect connection configuration
    package = lib.mkIf config.services.xserver.desktopManager.gnome.enable
      pkgs.gnomeExtensions.gsconnect;
  };
}
