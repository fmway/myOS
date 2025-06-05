{ internal, _file, name, inputs, selfInputs ? inputs, ... }:
{ inputs, pkgs, config, lib, ... }: let
  direnvrc = builtins.readFile ./direnv.sh;
in {
  inherit _file;
  programs.direnv = lib.mkMerge [
    {
      enable = true;
      nix-direnv.enable = true;
    }
    (let
      keys = lib.optionals (name != "homeManagerModules") [
        "direnvrcExtra"
      ] ++ lib.optionals (name == "homeManagerModules") [
        "stdlib"
      ];
    in lib.setAttrByPath keys direnvrc)
  ];
}
