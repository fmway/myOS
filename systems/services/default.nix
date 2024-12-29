{ pkgs
, pam-fingerprint
, lib
, config
, ...
}
:
{
  cloudflare-warp.enable = true;
  # Enable GNOME keyring.
  gnome.gnome-keyring.enable = true;

  # emulate /bin
  envfs.enable = true;

  # Enable Flatpak support
  flatpak.enable = true;

  # Enable fprintd and python-validity
  # open-fprintd.enable = true;
  # python-validity.enable = true;

  # Enable fwupd for updating firmware.
  fwupd.enable = true;

  openssh.enable = true;

  # gesture moments 😱
  # touchegg.enable = true; # nope, i use wayland

  samba-wsdd = {
    enable = config.services.samba.enable;
    openFirewall = true;
  };

  zfs.autoScrub.enable = true;
  zfs.trim.enable = true;

  # disable caps lock
  xserver.xkb.options = lib.mkAfter "grp:shifts_toggle,caps:none";

  # Enale throttled.service for fix Intel CPU throttling
  throttled.enable = true;

  # Enable thermald for CPU temperature auto handling
  thermald.enable = true;

  # Enable earlyoom for handling OOM conditions
  earlyoom = {
    enable = true;
    enableNotifications = true;
    freeMemThreshold = 2;
    freeSwapThreshold = 3;
  };

}
