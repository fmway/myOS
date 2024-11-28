# https://github.com/search?q=asu&type=repositories
{
  urls = [{
    template = "https://github.com/search";
    params = [
      { name = "q"; value = "{searchTerms}"; }
      { name = "type"; value = "repositories"; }
    ];
  }];
  icon = ./github.svg;
  definedAliases = [ "@gs" ];
}
