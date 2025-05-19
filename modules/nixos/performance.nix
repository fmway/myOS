{ lib, ... }:
{
  services = {
    # Enale throttled.service for fix Intel CPU throttling
    throttled.enable = lib.mkDefault true;

    # Enable thermald for CPU temperature auto handling
    thermald.enable = lib.mkDefault true;

    # Enable earlyoom for handling OOM conditions
    earlyoom = {
      enable = lib.mkDefault true;
      enableNotifications = true;
      freeMemThreshold = 2;
      freeSwapThreshold = 3;
    };
  };
}
