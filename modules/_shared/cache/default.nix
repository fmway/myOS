{ internal, _file, lib, ... }:
{ ... }:
{
  inherit _file;
  imports = lib.fmway.genImports ./.;
  nix.settings.substituters = ["https://cache.nixos.org/"];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
