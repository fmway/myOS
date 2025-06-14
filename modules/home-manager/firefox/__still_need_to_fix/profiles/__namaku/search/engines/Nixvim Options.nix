{
  urls = [{
    template = "https://nix-community.github.io/nixvim/search";
    params = [
      { name = "query"; value = "{searchTerms}"; }
    ];
  }];

  icon = ./nixvim.svg;
  definedAliases = [ "@nx" ];
}
