{ config, lib, ... }: let
  # config.set(xxx, yyy)
  uncommon = {
    config = {
      # fileselect.handler = "external";
    };
  };
in {
  imports = [
    (lib.mkAliasOptionModule [ "programs" "qutebrowser" "c" ] [ "programs" "qutebrowser" "settings" ])
  ];
  programs.qutebrowser = {
    keyBindings = {
      normal = {
        "<Alt-o>" = "cmd-set-text :open {url}";
        ";;" = "cmd-set-text :";
      };
    };
    enable = lib.mkDefault true;
    greasemonkey = [];

    c.auto_save.session = true;
    c.url.start_pages = "https://fmway.id";
    c.url.default_page= "https://fmway.id";
    
    extraConfig = let
      toPyValue = value:
        if isNull value then
          "None"
        else if lib.isString value then
          "'${value}'"
        else if lib.isList value then
          "[ ${lib.concatStringsSep ", " (map (x: toPyValue x) value)} ]"
        else if lib.isBool value then
          if value then
            "True"
          else "False"
        else toString value;
      describe = x: let
        func = key: y:
          if lib.isAttrs y then
            map (x: func (key ++ [ (lib.replaceStrings [ "-" ] [ "_" ] x) ]) y.${x}) (lib.attrNames y)
          else {
            inherit key;
            value = toPyValue y;
          };
      in lib.flatten (func [] x); 
      # toPy = x: lib.concatStringsSep "\n" (map (x: "${lib.concatStringsSep "." x.key} = ${x.value}") (describe x)) + "\n";
      toPyConfig = x: lib.concatStringsSep "\n" (map (x: "config.set('${lib.concatStringsSep "." x.key}', ${x.value})") (describe x)) + "\n";
    in 
      # lib.optionalString (uncommon.c or {} != {}) (toPy { inherit (uncommon) c; }) +
      lib.optionalString (uncommon.config or {} != {}) (toPyConfig uncommon.config);
    searchEngines = rec {
      nx = "https://nix-community.github.io/nixvim/search?query={}";
      gs = "https://github.com/search?q={}&type=repositories";
      gt = "https://github.com/search?q={}&type=topics";
      gu = "https://github.com/{}";
      hm = "https://home-manager-options.extranix.com/?type=packages&release=master&query={}";
      no = "https://search.nixos.org/options?type=packages&release=master&query={}";
      np = "https://search.nixos.org/packages?type=packages&release=master&query={}";
      w  = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
      g  = "https://www.google.com/search?q={}";
      b  = "https://www.bing.com/search?q={}";
      d  = "https://duckduckgo.com/?q={}";
      cb = "https://codeberg.org/{}";
      gl = "https://gitlab.org/{}";
      gls= "https://git.lix.systems/{}";
      DEFAULT = g;
    };
  };
}
