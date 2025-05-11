# TODO since i don't import my modules

{ pkgs, lib, ... }:
{
  enable = true;
  wrapperFeatures.gtk = true;
  checkConfig = false;
  package = pkgs.swayfx;
}
