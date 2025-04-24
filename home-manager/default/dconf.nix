{ pkgs, uncommon, lib, ... }:
let
  # parse normal attrs to dconf familiar
  dconfFamiliar = obj: let
    func = prefix: obj:
      lib.foldl' (res: x: let
        value = obj.${x};
      in res // (if lib.isAttrs value then
        func (prefix ++ [ x ]) value
      else {
        "${lib.concatStringsSep "/" prefix}"."${x}" = value;
      })) {} (lib.attrNames obj);
  in func [] obj;
in {
  enable = true;
  settings = dconfFamiliar uncommon.dconf.settings // 
  # custom shortuct
  (let
    keybindings = l: # list of { name ::: string, binding ::: string, command ::: string }
      lib.listToAttrs (lib.lists.imap0 (i: v: let
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
