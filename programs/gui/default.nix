{ pkgs, lib, config, ... }: let
  isGnomeEnabled = config.services.xserver.desktopManager.gnome.enable;
in { config = lib.mkIf (! config.data.isMinimal or false) {
  environment.systemPackages = with pkgs; [
    # session-desktop
    # protonmail-desktop
    appimagekit # ..
    # popsicle # bootable creator
    vscode # 🤫
    fmpkgs.xdman # xdm download manager
    mpv # video player
    # zed-editor # another text editor
    bottles # for management wine
    # google-chrome
    # youtube-music # ...
    gst_all_1.gstreamer # ...
    keepassxc # password manager
    # qutebrowser
    # fmpkgs.keypunch # monkeytype for gnome
    firefoxpwa # pwa for firefox

    # terminal
    # contour
    # wezterm
  ] ++ lib.optionals isGnomeEnabled [
    dconf-editor
    gnome-tweaks
    evolution
    # gdm-settings
    gnome-extension-manager
  ] ++ lib.optionals isGnomeEnabled (with gnomeExtensions; [
    paperwm
    appindicator
    clipboard-indicator
    thinkpad-battery-threshold
    blur-my-shell
    # net-speed
    lilypad
    emoji-copy
    day-progress
    totp
    bing-wallpaper-changer
    cloudflare-warp-toggle
    system-monitor
    weather-oclock
  ]);

  # programs.winbox = {
  #   enable = true;
  #   openFirewall = true;
  # };

  programs.noisetorch.enable = true;
}; }
