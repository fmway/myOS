{ lib, config, ... }: let
  cfg = config.home.file;
  home = config.home.homeDirectory;
  filtered = lib.attrNames cfg |> lib.filter (x: !cfg.${x}.symlink);
  isEnabled = lib.length filtered > 0;

  script = map (x: let
    self = cfg.${x};
  in  /* sh */ ''
    target=${home}/${self.target}
    ${if self.recursive then "rm -rf" else "unlink"} $target
    if test -f ${self.source}; then
      cat ${self.source} > $target
    else
      cp -rf ${self.source} $target
    fi
    ${lib.optionalString (! isNull self.executable && self.executable) "chmod -R +x $target"}
  '') filtered |> lib.concatStringsSep "\n";
in {
  options = let
    optionType = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.symlink = lib.mkEnableOption "" // { default = true; }; 
      });
    };
  in {
    home.file = optionType;
    xdg.configFile = optionType;
  };

  config = lib.mkIf isEnabled {
    home.activation.unlink = lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] script;
  };
}
