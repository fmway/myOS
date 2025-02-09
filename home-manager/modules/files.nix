{ lib, config, pkgs, ... }: let
  cfg = config.home.file;
  home = config.home.homeDirectory;
  filtered =  lib.filter (x: !cfg.${x}.symlink) (lib.attrNames cfg);
  isEnabled = lib.length filtered > 0;

  script = lib.concatStringsSep "\n" (map (x: let
    self = cfg.${x};
    tsource = pkgs.writeText x self.text;
    source = self.source or tsource;
  in  /* sh */ ''
    target=${home}/${self.target}
    ${if self.recursive then "rm -rf" else "unlink"} $target
    if test -f ${source}; then
      cat ${source} > $target
    else
      cp -rf ${source} $target
    fi
    ${lib.optionalString (! isNull self.executable && self.executable) "chmod -R +x $target"}
  '') filtered);
in {
  options = let
    optionType = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.symlink = lib.mkEnableOption "" // { default = true; }; 
      });
    };
  in {
    home.file = optionType;
    xdg = lib.genAttrs [ "configFile" "dataFile" "stateFile" ] (_: optionType);
  };

  config = lib.mkIf isEnabled {
    home.activation.unlink = lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] script;
  };
}
