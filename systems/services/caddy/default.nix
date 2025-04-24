{ config, domains, lib, ... }: let
  inherit (builtins) attrNames map;
  inherit (lib) listToAttrs;
in {
  enable = ! config.data.isMinimal or false;
  virtualHosts = listToAttrs (map (x: let
    v = domains.${x};
    enable = v.enable or true;
    matchType = lib.match "^(https?)$" (v.type or "");
  in {
    name = if isNull matchType then x else "${lib.elemAt matchType 0}://${x}";
    value = lib.mkIf enable (removeAttrs v [ "type" "enable" ]);
  }) (attrNames domains));
}
