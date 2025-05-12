{ lib, ... }:
{
  programs.starship = {
    enable = lib.mkDefault true;
    settings = {
      add_newline = false;
      enableTranscience = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
