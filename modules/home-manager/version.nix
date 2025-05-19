{ inputs, lib, ... }: let
  version = (with builtins;
    fromJSON (
      readFile "${inputs.home-manager}/release.json"
    )).release;
in {
  home.stateVersion = lib.mkDefault version;
}
