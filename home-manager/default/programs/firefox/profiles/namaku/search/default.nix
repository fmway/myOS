{ pkgs, ... }:
{
  default = "Google"; # default search engine
  privateDefault = "DuckDuckGo"; # default search engine in private mode
  force = true; # Force replace the existing search configuration

  # list search engines
  engines = {

    "Bing".metaData.alias = "b";
    "Wikipedia".metaData.alias = "w";
    "DuckDuckGo".metaData.alias = "d";
    "Google".metaData.alias = "g"; # builtin engines only support specifying one additional alias
  };
  # order = [
  #   "Bing"
  #   "Google"
  #   "DuckDuckGo"
  #   "NixOS Search"
  #   "Nixos Options"
  #   "Home Manager Options"
  # ];
}
