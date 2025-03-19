{ pkgs, ... }:
{
  rightbox-order =
    builtins.map (x: x.extensionPortalSlug) (with pkgs.gnomeExtensions; [
      system-monitor
      day-progress
      lilypad
    ]);
  lilypad-order =
    builtins.map (x: x.extensionPortalSlug) (with pkgs.gnomeExtensions; [
      emoji-copy
      totp
      clipboard-indicator
    ]);

  ignore-order = [];
}
