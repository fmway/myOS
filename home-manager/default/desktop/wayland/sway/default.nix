{ pkgs, lib, ... }:
{
  enable = true;
  wrapperFeatures.gtk = true;
  checkConfig = false;
}
