{ config, lib, ... }: {
  services.xserver.enable = true;

  # GDM
  services.xserver.displayManager.gdm.enable = lib.mkDefault (config.services.xserver.desktopManager.gnome.enable);
  services.xserver.desktopManager.gnome.enable = lib.mkDefault true;

  # Ly Display Manager
  # services.xserver.displayManager.ly.enable = true;

  # Keymap
  console.keyMap = "us";
  services.xserver.xkb = {
    layout = lib.mkDefault "us";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
