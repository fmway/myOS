{ pkgs, ... }:
{
  urls = [{
    template = "https://search.nixos.org/packages";
    params = [
      { name = "type"; value = "packages"; }
      { name = "channel"; value = "unstable"; }
      { name = "query"; value = "{searchTerms}"; }
    ];
  }];

  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  definedAliases = [ "@np" ];
}
