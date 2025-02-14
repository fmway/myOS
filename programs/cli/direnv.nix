{ inputs, lib, ... }: let
  direnvrcExtra = lib.fileContents ./direnv.sh;
in {
  enable = true;
  nix-direnv.enable = true;
  direnvrcExtra = /* sh */ ''
    source ${inputs.fmway-nix}/direnvrc
    ${direnvrcExtra}
  '';
}
