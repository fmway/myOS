{ inputs, lib, ... }: let
  version = lib.fileContents "${inputs.nixpkgs}/lib/.version";
in {
  system.stateVersion = lib.mkDefault version;
}
