{ internal, self, name, inputs, selfInputs ? inputs, ... }:
{ inputs, lib, pkgs, config, osConfig ? {}, ... }: let
  nixpkgs-overlay = self: super: let
    overlayNixpkgs = arr: obj: lib.foldl' (acc: curr: let
      name = "_${curr}";
      importName =
        inputs.${curr} or
        inputs."$nixpkgs-${curr}" or
        selfInputs.${curr} or
        selfInputs."nixpkgs-${curr}";
    in {
      "${name}" = import importName {
        inherit (pkgs) system;
        inherit (config.nixpkgs) config;
      };
    } // acc) obj arr;
  in overlayNixpkgs [ "master" "24_11" "25_05" ] {};
in {
  _file = ./overlay.nix;
  config = lib.mkIf (name != "homeManagerModules" || ! osConfig.home-manager.useGlobalPkgs or true) {
    nixpkgs.overlays = [
      self.overlays.default
      nixpkgs-overlay
    ];
  };
}
