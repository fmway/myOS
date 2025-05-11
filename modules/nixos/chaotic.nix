{ inputs, lib, config, pkgs, ... }:
{
  _file = ./chaotic.nix;
  imports = [
    inputs.chaotic.nixosModules.default
  ];

  services.scx.enable = lib.mkDefault true;
  services.scx.package = lib.mkDefault (pkgs.scx_git or pkgs.scx).full;
  services.scx.scheduler = lib.mkDefault "scx_bpfland";
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;
  boot.zfs.package = lib.mkDefault pkgs.zfs_cachyos;
}
