{ self, lib, super, ... }:
super.swayfx-unwrapped.overrideAttrs (old: {
  mesonFlags = (old.mesonFlags or []) ++ [
    (lib.strings.mesonBool "werror" false)
  ];
})
