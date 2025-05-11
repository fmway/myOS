{ config, pkgs, lib, ... } @ v:
{
  # TODO auto-import
  xdg.configFile = {
    "contour/contour.yml".source = ./contour/contour.yml;
    "zellij/layouts/fmlayout.kdl".source = ./zellij/layouts/fmlayout.kdl;
    "zellij/config.kdl".text = import ./zellij/config.kdl.nix v;
  };
}
