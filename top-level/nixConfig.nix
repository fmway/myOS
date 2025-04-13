{ inputs, lib, ... }:
{
  flake.nixConfig = let
    pkgs = {};
    module = lib.evalModules {
      modules = [
        ({ config, ... }: {
          options.nix.settings =
            (import "${inputs.nixpkgs}/nixos/modules/config/nix.nix"
              { inherit lib config pkgs; }).options.nix.settings;
        })
        ../cachix.nix
        ({ config, ... }: {
          nix = {
            inherit (import ../systems/nix.nix { inherit lib config pkgs inputs; })
            settings;
          };
        })
        {
          nix.settings.trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        }
      ];
      specialArgs = { inherit pkgs lib; };
    };
  in module.config.nix.settings;
}
