{
  urls = [{
    template = "https://home-manager-options.extranix.com/";
    params = [
      { name = "type"; value = "packages"; }
      { name = "release"; value = "master"; }
      { name = "query"; value = "{searchTerms}"; }
    ];
  }];

  definedAliases = [ "@hm" ];
}
