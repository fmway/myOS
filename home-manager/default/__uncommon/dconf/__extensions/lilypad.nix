{ pkgs, ... }:
{
  rightbox-order = [
    "Day_Progress"
    "system_monitor"
    "lilypad"
  ];
  lilypad-order = [
    "steam"
    "StatusNotifierItem"
    "BingWallpaperIndicator"
    "emoji_copy"
    "totp"
    "clipboardIndicator"
  ];

  ignore-order = [];
}
