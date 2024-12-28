{ lib, config, inputs, ... }:
{
  nix = {
    registry = builtins.attrNames inputs
      |> map (x: {
        name = x;
        value.flake = inputs.${x};
      })
      |> builtins.listToAttrs;

    nixPath = builtins.attrNames inputs
      |> map (name: "${name}=${inputs.${name}.outPath}");
  };
  environment.etc = let
    inherit (builtins) listToAttrs attrNames map;
    nix-inputs = attrNames inputs
      |> map (x: {
        name = "nix/inputs/${x}";
        value.source = inputs.${x}.outPath;
      })
      |> listToAttrs;
  in nix-inputs;
}
