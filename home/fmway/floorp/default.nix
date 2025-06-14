{ internal, _file, lib, ... } @ v:
{ config, pkgs, osConfig ? {}, ... } @ w:
{
  inherit _file;
  programs.floorp = lib.fmway.treeImport {
    folder = ./__still_need_to_fix;
    depth = 0;
    variables = v // w;
  };
}
