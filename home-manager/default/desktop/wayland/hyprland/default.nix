{ pkgs, uncommon, lib, config, ... }: let
  parseBind = prefix: obj:
    lib.attrNames obj |> map (x: let
      key = lib.splitString "+" x
      |> (y: let
        length = lib.length y;
        h = if length == 1 then "" else lib.take (length - 1) y |> lib.concatStringsSep " ";
        t = lib.last y;
      in [ h t ]);
      toValue = v:
        lib.splitString " " obj.${x}
        |> (y: let
          h = lib.head y;
          t = lib.tail y |> lib.concatStringsSep " ";
        in [ h ] ++ lib.optionals (lib.length y != 1) [ t ]);
      value = lib.flatten [ obj.${x} ] |> map (x: toValue x);
    in map (z: lib.concatStringsSep ", " (key ++ z) |> (zz: "${prefix} = ${lib.trim zz}")) value)
  ;

  parseBinds = { ... } @ args: let
    binds = lib.attrNames args |> lib.filter (x: lib.hasPrefix "bind" x);
    result = map (x: parseBind x args.${x}) binds;
  in lib.optionals (binds != [] && lib.any (x: args.${x} != {}) binds) result;

  parseEnv = obj:
    lib.attrNames obj
    |> map (key: let
      value = if lib.isString obj.${key} then
        obj.${key}
      else builtins.toJSON obj.${key};
    in "env = ${key},${value}")
  ;

  parseWindowRule = obj: let
    parseVal = key: o:
      lib.attrNames o
      |> lib.filter (x: ! lib.isBool o.${x} || o.${x})
      |> map (x: let
        value = toValue o.${x};
        name = "windowrule" + lib.optionalString (!isNull (lib.match ".*:.*" key)) "v2";
      in "${name} = ${lib.concatStringsSep " " ([ x ] ++ lib.optionals (!lib.isBool o.${x}) [ value ])}, ${key}")
      |> lib.concatStringsSep "\n";
    toValue = value:
      (if lib.isString value then
        [ value ]
      else if lib.isList value then
        map (x: if lib.isString x then x else builtins.toJSON x) value
        |> lib.concatStringsSep " "
      else builtins.toJSON value);
  in
    lib.attrNames obj
    |> map (x: parseVal x obj.${x})
  ;

  parseSubMap = name: { cause, reset ? [], ... } @ args:
    [ "# => ${name}" ] ++
    (lib.flatten [ cause ] |> map (x: { name = x; value = "submap ${name}"; }) |> lib.listToAttrs |> parseBind "bind") ++
    ["submap = ${name}"] ++
    (parseBinds args) ++ [ "" ] ++
    (lib.flatten [ reset ] |> map (x: { name = x; value = "submap reset"; }) |> lib.listToAttrs |> parseBind "bind") ++
    [
      "submap = reset"
      "# <= ${name}"
    ]
  ;
in {
  enable = lib.mkDefault false;

  systemd.enableXdgAutostart = true;
  xwayland.enable = true;

  extraConfig = let
    parse = { env ? {}, submap ? {} , windowRule ? {}, ... } @ args:
      lib.optionals (env != {}) ([ "# Environment" ] ++ parseEnv uncommon.env ++ [""]) ++
      (let binds = parseBinds args; in lib.optionals (binds != []) ([ "" "# General Keybindings" ] ++ binds)) ++
      lib.optionals (submap != {}) (lib.attrNames submap |> map (x: parseSubMap x submap.${x} ++ [ "" ])) ++
      lib.optionals (windowRule != {}) ([ "# Window Rule" ] ++ parseWindowRule windowRule)
      |> lib.flatten |> lib.concatStringsSep "\n"
    ;
  in parse uncommon;
}
