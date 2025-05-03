{ pkgs, ... }:
{

  # Override default Dconf settings.
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverridePackages = with pkgs;[
      gsettings-desktop-schemas # for org.gnome.desktop
      gnome-shell # for org.gnome.shell
    ];
  };

  # packages
  environment.systemPackages = with pkgs; [
    adw-gtk3
  ];

  # Add list DE/WM
  services.windowManager = {
    sway.enable = true;
    niri.enable = true;
  };
  
  # Enable ls colors in Bash
  programs.bash.enableLsColors = true;
}
