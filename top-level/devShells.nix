{ self, ... }: {
  perSystem = { pkgs, system, lib, ... }: let
    mkShell = lib.fmway.createShell pkgs;
  in {
    devShells.default =
      lib.throwIf (system != "x86_64-linux") "only for x86_64-linux"
      mkShell ({ pkgs, self', config, ... }: {
        imports = [
          { _module.args.pkgs = self.legacyPackages.${system}; }
        ];
        NIX_PATH = "pkgs=${self.outPath}";
        buildInputs = with pkgs; [
        ];
      });
  };
}
