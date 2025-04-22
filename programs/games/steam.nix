{ pkgs, lib, config, ... }:
{
  enable = lib.mkDefault (! config.data.isMinimal or false);
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true;
  gamescopeSession = {
    enable = true;
    # env = {};
    # args = [];
  };

  protontricks.enable = true;
  extraPackages = with pkgs; [
  ];
  extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
}
