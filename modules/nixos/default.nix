{ internal, allModules, _file, ... }:
{ inputs ? {}, lib, ... }:
{
  inherit _file;
  imports = allModules ++ [
    inputs.fmway-nix.nixosModules.all
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
