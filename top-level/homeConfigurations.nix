{ inputs, self, ... }:
{
  flake.homeConfigurations.default = let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    inherit (self.lib.genSpecialArgs {
      inherit system inputs;
    }) extraSpecialArgs;
    modules = [
      self.homeManagerModules.modules
      self.homeManagerModules.another
    ];
  };
}
