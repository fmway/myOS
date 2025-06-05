{ internal, _file, inputs, superInputs ? inputs, ... }:
{ lib, inputs ? {}, ... }:
{
  inherit _file;
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    backupFileExtension = "hm-backup~.${toString inputs.self.lastModified}";
    sharedModules = [
      # homeManagerModules.default
      # self.homeManagerModules
      # (inputs.catppuccin or superInputs.catppuccin).homeModules.catppuccin
    ];
    extraSpecialArgs = {
      inputs = superInputs // inputs;
    };
  };
}
