{ config, pkgs, lib, osConfig ? {}, ... } @ variables:
{
  programs.floorp = lib.fmway.treeImport {
    folder = ./__still_need_to_fix;
    depth = 0;
    inherit variables;
  };
}
