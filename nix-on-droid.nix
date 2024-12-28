{ config, lib, pkgs, ... }:

{
  # termux integration
  android-integration = {
    am.enable = true; # termux-am
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    unsupported.enable = true;
    xdg-open.enable = true;
  };

  # custom variable
  environment.sessionVariables = {
    TEST = "kuy";
    EDITOR = "vim";
  };

  # default shell
  user.shell = lib.getExe pkgs.fish; # change pkgs.fish with your favorite shell

  # Simply install just the packages
  environment.packages = with pkgs; [
    
  ];

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes pipe-operators
  '';

  # Set your time zone
  time.timeZone = "Asia/Jakarta";

  # TODO set terminal font
  # terminal.font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF.ttf";
}
