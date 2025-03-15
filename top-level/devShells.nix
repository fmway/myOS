{ self, ... }: {
  perSystem = { pkgs, system, lib, ... }: let
    mkShell = lib.fmway.createShell pkgs;
  in {
    devShells.default =
      lib.throwIf (system != "x86_64-linux") "only for x86_64-linux"
      (mkShell ({ pkgs, self', config, ... }: {
        imports = [
          { _module.args.pkgs = self.legacyPackages.${system}; }
        ];
        NIXD_PATH =
          lib.concatStringsSep ":" [
            "pkgs=${self.outPath}#nixosConfigurations.minimal.pkgs"
            "nixos=${self.outPath}#nixosConfigurations.minimal.options"
            "home-manager=${self.outPath}#nixosConfigurations.minimal.config.home-manager.users.fmway.data.options"
            "nixvim=${self.outPath}#nixosConfigurations.minimal.options.programs.nixvim"
          ];
        buildInputs = with pkgs; [
        ];
      }) // { nixvim.options = let
        opt = self.nixosConfigurations.minimal.options.programs.nixvim.type;
      in opt.getSubOptions [ opt.getSubModules ]; });
  };
}
