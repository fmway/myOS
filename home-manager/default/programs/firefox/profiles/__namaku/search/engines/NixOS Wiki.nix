{
  urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
  iconUpdateURL = "https://wiki.nixos.org/favicon.png";
  updateInterval = 24 * 60 * 60 * 1000; # every day
  definedAliases = [ "@nw" ];
}
