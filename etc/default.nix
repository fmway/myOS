{ pkgs, lib, ... }:
# TODO auto import
{ environment.etc = {
  "nanorc".text = ''
    include "${pkgs.nano}/share/nano/*.nanorc"
    include "${pkgs.nano}/share/nano/extra/*.nanorc"

  '' + (lib.fileContents ./nanorc);
};
  environment.motd = lib.fileContents ./motd;
  imports = [
    ./nix.nix
  ];
}
