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

  services = {
    # disable caps lock
    xserver.xkb.options = lib.mkAfter "grp:shifts_toggle,caps:none";

    # Enale throttled.service for fix Intel CPU throttling
    throttled.enable = lib.mkDefault true;

    # Enable thermald for CPU temperature auto handling
    thermald.enable = lib.mkDefault true;

    # Enable earlyoom for handling OOM conditions
    earlyoom = {
      enable = lib.mkDefault true;
      enableNotifications = true;
      freeMemThreshold = 2;
      freeSwapThreshold = 3;
    };
  };
}
