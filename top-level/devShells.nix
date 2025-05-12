{ self, ... }:
{
  perSystem = { pkgs, system, lib, ... }: {
    devShells.default = pkgs.mkShellNoCC {
      NIXD_PATH = lib.concatStringsSep ":" [
        "pkgs=${self.outPath}#legacyPackages.${system}"
        "nixos=${self.outPath}#nixosConfigurations.Namaku1801.options"
        "home-manager=${self.outPath}#nixosConfigurations.Namaku1801.options.home-manager.users.type.getSubOptions []"
      ];
    };
  };
}
