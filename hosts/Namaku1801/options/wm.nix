{ config, lib, pkgs, ... }: let
  toOptions = name: {
    enable = lib.mkEnableOption "add ${name} to display manager";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.${name};
      description = "spesifict package";
    };
  };
  cfg = config.services.windowManager;
  wm = [
    "hyprland"
    "niri"
    "sway"
  ];
in {
  options.services.windowManager = lib.listToAttrs (
    map (name: {
      inherit name;
      value = toOptions name;
    }) wm
  );
  config.services.displayManager.sessionPackages = let
    filtered = lib.filter (x: cfg.${x}.enable) wm;
  in map (x: cfg.${x}.package) filtered;
}
