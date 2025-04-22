{ lib, ... }:
with lib.hm.gvariant; {
  active-keybind = mkBoolean true;
  always-show = mkBoolean false;
  paste-on-select = mkBoolean true;
  emoji-keybind = mkArray type.string ["<Super>colon"];
}
