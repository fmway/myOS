{ config, lib, ... }: let
  BROWSER_DIRS = [
    ".mozilla/firefox"
    ".floorp"
  ]
  |> map (x: "'${config.home.homeDirectory}/${x}'")
  |> lib.concatStringsSep " "
  |> (final: "(${final})");
in {
  removePlacesFirefox = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] /* sh */ ''
    BROWSER_DIRS=${BROWSER_DIRS}
    
    for dir in ''${BROWSER_DIRS[@]}; do
      find $dir -name 'places.sqlite*' | while read file; do
        rm -vfr $file
      done
    done
  '';
}
