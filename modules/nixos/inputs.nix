{ internal, _file, inputs, selfInputs ? inputs, ... }:
{ inputs ? {}, lib, ... }: let
  finalInputs = selfInputs // inputs;
in {
  inherit _file;

  # links all inputs to /etc/nix/inputs
  environment.etc = lib.mapAttrs' (k: v:
    lib.nameValuePair "nix/inputs/${k}" {
      source = v.outPath;
    }
  ) finalInputs;

  # register all inputs to nix registry
  nix.registry = lib.mapAttrs' (k: flake:
    lib.nameValuePair (if k == "self" then "nixos" else k) (lib.mkOverride 60 {
      inherit flake;
    })
  ) finalInputs;

  # register all inputs to nixPath (for legacy nix)
  nix.nixPath = map (name:
    "${name}=${finalInputs.${name}.outPath}"
  ) (lib.attrNames finalInputs);
}
