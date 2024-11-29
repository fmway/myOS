{ pkgs, config, lib, ... }:
{
  enable = true;
  package = lib.mkIf (
    pkgs ? linuxPackages_cachyos &&
    config.boot.kernelPackages == pkgs.linuxPackages_cachyos
  ) (pkgs.scx_git or pkgs.scx).full;
  scheduler = "scx_lavd";
}
