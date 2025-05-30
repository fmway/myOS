{ pkgs, lib, ... }:
{
  programs.kdeconnect.enable = lib.mkDefault true;
}
