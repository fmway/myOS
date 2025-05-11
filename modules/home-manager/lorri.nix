{ lib,... }:
{
  services.lorri = {
    enable = lib.mkDefault true;
    enableNotifications = true;
  };
}
