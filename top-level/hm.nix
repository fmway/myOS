{ inputs, lib, version, ... }:
{
  flake.homeManagerModules = let
    hmDir = ../home-manager;
    self = {
      modules =
        lib.optionals (builtins.pathExists (hmDir + "/modules")) (lib.fmway.genImportsWithDefault (hmDir + "/modules")) ++ [
          (lib.mkAliasOptionModule [ "nix" "gc" "dates" ] [ "nix" "gc" "frequency" ])
          (lib.mkAliasOptionModule [ "programs" "qutebrowser" "c" ] [ "programs" "qutebrowser" "settings" ])
          ({ options, ... }: {
            _file = ./hm.nix;
            config.data = { inherit options; };
          })
        ] ++ map (x:
          lib.mkAliasOptionModule [ "home" x ] [ x ]
        ) [ "catppuccin" "dconf" ];
      only = [ (hmDir + "/default") ];
      another = with inputs; [
        catppuccin.homeModules.catppuccin
        fmway-nix.homeManagerModules.fmway
      ];
    };
    selfNames = builtins.attrNames self;
  in builtins.foldl' (acc: name: acc // {
    "${name}".imports = lib.flatten [ self.${name} ];
  }) { 
    default.imports = lib.flatten (map (x: self.${x}) selfNames ++ [
      ({ lib, ... }: {
        programs.fish.generateCompletions = lib.mkDefault false;
        home.stateVersion = lib.mkDefault version;
      })
    ]);
  } selfNames;
}
