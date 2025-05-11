{ lib, ... }:
{
  programs.fastfetch = {
    enable = lib.mkDefault true;
    settings = builtins.fromJSON (lib.fileContents ./settings.json);
  };
}
