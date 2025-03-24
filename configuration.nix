{ lib, ... }:
{ 
  system.stateVersion = lib.fileContents ./.version;
}
