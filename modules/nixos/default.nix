{ internal, allModules, ... }:
{ inputs ? {}, lib, ... }:
{
  _file = ./default.nix;
  imports = allModules ++ [
    inputs.fmway-nix.nixosModules.default
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.adb.enable = lib.mkDefault true;

  # emulate /bin
  services.envfs.enable = true;

  # disable caps lock
  services.xserver.xkb.options = lib.mkAfter "grp:shifts_toggle,caps:none";
}
