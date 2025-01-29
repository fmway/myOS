{ pkgs
, config
, root-path
, inputs
, system
, lib
, ...
} @ variables
: let
  inherit (lib.fmway)
    treeImport
  ;
  inherit (builtins) 
    foldl'
    ;
  nixpkgs-overlay = self: super: let
    overlayNixpkgs = arr: obj: foldl' (acc: curr: let
      name = "_${curr}";
      importName =
        if inputs ? ${curr} then
          inputs.${curr}
        else inputs."nixpkgs-${curr}";
    in {
      "${name}" = import importName {
        inherit system;
        config.allowUnfree = true;
      };
    } // acc) obj arr;
  in overlayNixpkgs [ "master" "24_05" "24_11" ] {
    fmpkgs = import inputs.fmpkgs {
      inherit system pkgs lib;
    };
  };

  package-overlay = self: super: treeImport {
    encore = inputs.encore.packages.${self.system}.encore;
  } {
    folder = ./.;
    variables = variables // { inherit self super; };
    excludes = [
      "qutebrowser"
    ];
  };
in {
  nixpkgs.overlays = [
    inputs.agenix.overlays.default
    nixpkgs-overlay
    package-overlay
    inputs.nur.overlays.default
    inputs.nixgl.overlay
  ];
}
