{ lib, ... }:
{
  programs.starship = {
    enable = lib.mkDefault true;
    enableTransience = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
