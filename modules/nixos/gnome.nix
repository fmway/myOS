{ lib, pkgs, config, ... }:
{
   # GDM
  services.xserver.displayManager.gdm.enable = lib.mkDefault (config.services.xserver.desktopManager.gnome.enable);
  services.xserver.desktopManager.gnome.enable = lib.mkDefault true;

  # enable GNOME keyring
  services.gnome.gnome-keyring.enable = lib.mkDefault true;

  # Exclude packages from the gnome.
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-maps
    geary
    gnome-tour
    # gnome-software
    gnome-contacts
  ];

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
}
