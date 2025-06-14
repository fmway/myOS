# FIXME support auto-import OOTB, so i don't fucking need to reimporting
{ internal, _file, lib, ... } @ v:
{ config, pkgs, osConfig ? {}, ... } @ w:
{
  inherit _file;
  programs.floorp = lib.fmway.treeImport {
    folder = ./firefox/__still_need_to_fix;
    depth = 0;
    variables = v // w;
  };
}
