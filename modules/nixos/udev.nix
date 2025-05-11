{ pkgs, ... }:
{
  services.udev = {
    packages = with pkgs; [
      android-udev-rules
      gnome-settings-daemon
    ];
  };
}
