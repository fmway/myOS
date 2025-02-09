{
  urls = [{
    template = "https://github.com/search";
    params = [
      { name = "q"; value = "{searchTerms}"; }
      { name = "type"; value = "topics"; }
    ];
  }];
  icon = ./github.svg;
  definedAliases = [ "@gt" ];
}
