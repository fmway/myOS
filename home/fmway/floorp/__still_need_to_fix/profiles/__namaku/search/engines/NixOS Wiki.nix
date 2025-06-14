{ pkgs, ... }:
{
  urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  updateInterval = 24 * 60 * 60 * 1000; # every day
  definedAliases = [ "@nw" ];
}
