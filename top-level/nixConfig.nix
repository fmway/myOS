{ inputs, config, lib, ... }:
{
  flake.nixConfig = let
    pkgs = {};
    excludes = [ "allowed-users" "system-features" "trusted-users" "cores" "auto-optimise-store" "max-jobs" "require-sigs" "sandbox" "extra-sandbox-paths" "gc" ];
    module = lib.evalModules {
      modules = [
        ({ config, ... }: {
          options.nix.settings =
            (import "${inputs.nixpkgs}/nixos/modules/config/nix.nix"
              { inherit lib config pkgs; }).options.nix.settings;
        })
        config.flake.nixosModules.cache
        # config.flake.nixosModules.nix
        {
          nix.settings.trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        }
      ];
      specialArgs = { inherit pkgs lib; };
    };
  in removeAttrs module.config.nix.settings excludes;
}
