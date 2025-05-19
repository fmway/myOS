{ inputs, lib, ... }: let
  version = lib.fileContents "${inputs.nixpkgs}/lib/.version";
in {
  _file = ./version.nix;
  system.stateVersion = lib.mkDefault version;
}
