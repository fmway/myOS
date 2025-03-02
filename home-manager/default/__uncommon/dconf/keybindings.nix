{ lib, pkgs, ... }: let
  bash = name: script:
    pkgs.writeScript name ''
      #!${lib.getExe pkgs.bash}

      ${script}
    '';
in [
  {
    name = "increment cursor size";
    binding = "<Alt><Super>equal";
    command = bash "increment-cursor" /* sh */ ''
      CURRENT=$(gsettings get org.gnome.desktop.interface cursor-size)
      gsettings set org.gnome.desktop.interface cursor-size $(( CURRENT + 1 ))
    '';
  }
  {
    name = "decrement cursor size";
    binding = "<Alt><Super>minus";
    command = bash "decrement-cursor" /* sh */ ''
      CURRENT=$(gsettings get org.gnome.desktop.interface cursor-size)
      [ ! -z $CURRENT ] &&
        [ $CURRENT -ge 1 ] &&
        gsettings set org.gnome.desktop.interface cursor-size $(( CURRENT - 1 ))
    '';
  }
]
