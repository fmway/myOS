{ self, lib, super, ... }:
{
  __output.mesonFlags.__append = [
    (lib.strings.mesonBool "werror" false)
  ];
  __input.trayEnabled.__assign = false;
}
