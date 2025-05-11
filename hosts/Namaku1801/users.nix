{ pkgs, ... }:
{
  users.users.fmway = {
    description = "fmway";
    home = "/home/fmway";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager" 
      "docker" 
      "wheel"
      "video"
      "gdm"
      "dialout"
      "kvm"
      "adbusers"
      "vboxusers"
      "fwupd-refresh"
    ];
    isNormalUser = true;
  };

  nix.settings = {
    trusted-users = [
      "fmway"
    ];
  };

  # register fmway to VirtualBox group 
  users.extraGroups.vboxusers.members = [
    "fmway"
  ];
}
