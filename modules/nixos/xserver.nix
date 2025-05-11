{ config, pkgs, lib, ... }: {
  services.xserver.enable = true; 

  # Ly Display Manager
  # services.xserver.displayManager.ly.enable = true;

  # Keymap
  console.keyMap = "us";
  services.xserver.xkb = {
    layout = lib.mkDefault "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  # Exclude packages from the X server.
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}
