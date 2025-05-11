{ inputs, self, config, lib, ... }:
{
  perSystem = { pkgs, inputs', ... }: {
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs:
        inputs'.nixvim.legacyPackages;
    };

    packages.nixvim = pkgs.makeNixvimWithModule {
      module.imports = [
        inputs.nxchad.nixvimModules.default
        config.flake.nixvimModules.default
      ];
    };
  };
}
