{ pkgs, ... }: pkg: pkgs.symlinkJoin {
  inherit (pkg) pname name version meta;
  paths = [pkg];
  postBuild = /* sh */ ''
    mkdir $out
    cp -rf * $out/
    rm -rf $out/etc $out/lib
  ''; # remove autostart, very annoying
}
