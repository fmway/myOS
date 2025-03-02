{ pkgs, uncommon, lib, ... }:
let
  # parse normal attrs to dconf familiar
  dconfFamiliar = obj: let
    func = prefix: obj:
      builtins.foldl' (res: x: let
        value = obj.${x};
      in lib.recursiveUpdate res (if builtins.isAttrs value then let
        key = if prefix == "" then x else builtins.concatStringsSep "/" [ prefix x ];
      in 
        func key value
      else {
        "${prefix}"."${x}" = value;
      })) {} (builtins.attrNames obj);
  in func "" obj;
in {
  enable = true;
  settings = dconfFamiliar uncommon.dconf.settings // 
  # custom shortuct
  (let
    keybindings = l: # list of { name ::: string, binding ::: string, command ::: string }
      builtins.listToAttrs (lib.lists.imap0 (i: v: let
        key = "custom${toString i}";
      in {
        name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${key}";
        value = with lib.gvariant; {
          name = mkString (v.name or key);
          binding = mkString v.binding;
          command = mkString "${v.command}";
        };
      }) l);
  in keybindings uncommon.dconf.keybindings);
}
