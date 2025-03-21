{ pkgs, ... }:
{
  default = "google"; # default search engine
  privateDefault = "ddg"; # default search engine in private mode
  force = true; # Force replace the existing search configuration

  # list search engines
  engines = {

    "bing".metaData.alias = "b";
    "Wikipedia".metaData.alias = "w";
    "ddg".metaData.alias = "d";
    "google".metaData.alias = "g"; # builtin engines only support specifying one additional alias
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
