{ internal, name, ... }:
{ lib, pkgs, ... }:
{
  _file = ./nix.nix;
  nix.settings = {
    substituters = [];
    trusted-public-keys = [];

    auto-optimise-store = lib.mkDefault false;
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 3d";
  };
   
  # automatic nix gc every mondays and fridays
  imports = let
    dates = "Mon,Fri *-*-* 00:00:00";
  in lib.optionals (name == "nixosModules")
    [ { nix.gc.dates = dates; } ]
  ++ lib.optionals (name == "homeManagerModules")
    [ { nix.gc.frequency = dates; } ]
  ++ lib.optionals (name == "nixDarwinModules")
    [
      { nix.gc.interval = [
        {
          Hour = 0;
          Minute = 0;
          WeekDay = 5;
        }
        {
          Hour = 0;
          Minute = 0;
          WeekDay = 1;
        }
      ]; }
    ];
}
