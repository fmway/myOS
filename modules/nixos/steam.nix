{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # steamcmd
    # steam-tui
  ];

  # required for steam gamescope
  programs.gamescope = lib.mkIf config.programs.steam.enable {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = lib.mkDefault true;
    remotePlay.openFirewall = true;

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
  };
}
