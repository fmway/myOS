{
  description = "My NixOS configuration";
  # Inputs
  inputs = {
    h-m-m.url = "github:nadrad/h-m-m";
    h-m-m.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-24_11.url = "github:NixOS/nixpkgs/nixos-24.11";
    master.url = "github:NixOS/nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    # TODO implement impermanence
    # impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };
    fmway-nix = {
      url = "github:fmway/fmway.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flox.url = "github:flox/flox/v1.3.17";
    fmpkgs.url = "github:fmway/fmpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    encore.url = "github:encoredev/encore-flake";
    encore.inputs.nixpkgs.follows = "nixpkgs";
    # TODO
    # nix-colors.url = "github:misterio77/nix-colors";
    home-manager.url = "github:nix-community/home-manager/master";
    # nixgl.url = "github:nix-community/NixGL";
    nur.url = "github:nix-community/nur";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    systems.url = "github:nix-systems/default";
    nxchad.url = "github:fmway/nxchad";
    nxchad.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, nxchad, fmway-nix, ... } @ inputs: let
    inherit (fmway-nix) lib;
  in lib.mkFlake {
      inherit inputs;
      specialArgs = {
        lib = [
          home-manager.lib
          nxchad.lib
          {
            inherit (fmway-nix) infuse;
          }
          (self: super: import ./lib { lib = self; })
        ];
      };
    } {
      imports = lib.fmway.genImports ./top-level ++ [
        ({ self, config, modulesPath, lib, ... } @ v: {
          flake = lib.fmway.genModules ./modules v;
          _module.args.modulesPath = "${self.outPath}/modules";
        })
        ({ lib, ... }: { flake = { inherit lib; }; })
      ];
    };
  nixConfig = {
    extra-trusted-substituters = [
      "https://cache.nixos.org/"
      "https://chaotic-nyx.cachix.org"
      "https://devenv.cachix.org"
      "https://fmcachix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "fmcachix.cachix.org-1:Z5j9jk83ctoCK22EWrbQL6AAP3CTYnZ/PHljlYSakrw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };
}
