{ config, pkgs, ... }:
{
  enable = ! config.data.isMinimal or false;
  config = {
    volume-max = "300";
    hwdec = "auto-safe";
    vo = "gpu";
    profile = "gpu-hq";
    gpu-context = "wayland";
  };
  bindings = {};

  scripts = (with pkgs.mpvScripts;
  [
    youtube-upnext
    webtorrent-mpv-hook
    visualizer
    sponsorblock
    # seekTo
    reload
    quality-menu
    quack
    mpv-playlistmanager
    autosubsync-mpv
    # mpv-osc-modern
    mpv-cheatsheet
    mpris
    # modernx
    memo
    thumbfast
    # manga-reader
    inhibit-gnome
    evafast
    uosc
  ]) ++ (with pkgs.fmpkgs.mpv-scripts; [
    multiloop
    menu
    bookmarker
  ]);
}
