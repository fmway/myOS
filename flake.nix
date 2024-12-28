{
  description = "Basic example of Nix-on-Droid system config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "unstable";
    };

    nvchad.url = "github:fmway/nvchad.nix";
    nvchad.inputs = {
      nixpkgs.follows = "unstable";
      nixvim.follows = "nixvim";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "unstable";
    
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nix-on-droid, ... } @ inputs: {
    templates.default = {
      path = ./.;
      description = "My configuration nix on android";
    };
    nixOnDroidConfigurations.default = let
      system = "aarch64-linux"; # change to your system
      pkgs = import inputs.unstable {
        allowUnfree = true;
        inherit system;
        config.packageOverrides = _: rec {
          unstable = pkgs;
          nvchad = inputs.nvchad.packages.${system};
          neovim = nvchad.simple;
        };
      };
    in nix-on-droid.lib.nixOnDroidConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
        inherit (self) outputs;
      };
      modules = [
        ./nix-on-droid.nix
        ./etc
        ({ ... }: {
          environment.etcBackupExtension = ".backup~.${toString self.lastModified}";
          home-manager = {
            backupFileExtension = "backup~.${toString self.lastModified}";
            config = { ... }: {
              imports = [ ./home-manager ];
              nix.registry = {
                nixpkgs.flake = nixpkgs;
                nix-on-droid.flake = nix-on-droid;
                self.flake = self;
              };
            };
            sharedModules = [];
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        })
      ];
    };

  };
}
