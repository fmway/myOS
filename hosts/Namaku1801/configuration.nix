{ internal, inputs, config, self, selfInputs ? inputs, ... }:
{ inputs, config, lib, pkgs, ... }:
{
  imports = with inputs; [
    ./hardware-configuration.nix
    ./disko.nix
    ./forgejo.nix
    ./caddy.nix
    ./users.nix
    ./options
    ../../secrets
    nixos-hardware.nixosModules.lenovo-thinkpad-t480
    disko.nixosModules.default
    agenix.nixosModules.default
    self.nixosModules.default
    fmpkgs.nixosModules.default
    nixvim.nixosModules.nixvim
    nxchad.nixosModules.nixvim
    lix-module.nixosModules.default
  ];

  nix.settings.experimental-features = [
    ("pipe-operator" + lib.optionalString (!config.lix.enable) "s")
  ];

  programs.nixvim.enable = true;
  programs.nixvim.imports = [
    self.nixvimModules.default
  ];

  environment.systemPackages = with pkgs; [
    agenix
    google-authenticator
  ];

  home-manager.users.fmway.imports = [
    self.homeConfs.fmway
    {
      # disable ~/.config/nix/nix.conf since that's is already define in /etc/nix/nix.conf
      xdg.configFile."nix/nix.conf".enable = false;
    }
  ];

  nixpkgs.overlays = [
    (inputs.agenix or selfInputs.agenix).overlays.default
  ];

  nix.extraOptions = ''
    !include ${config.age.secrets.nix.path}
  '';

  # enable google totp in ssh login
  security.pam.services.sshd.googleAuthenticator.enable = true;

  # for background
  environment.etc."current-background".source = ./background.jpg;

  # enable flatpak support
  services.flatpak.enable = true;

  # Enable fwupd for updating firmware
  services.fwupd.enable = true;

  services.tailscale.enable = lib.mkDefault true;
  services.tailscale.authKeyFile = lib.mkDefault config.age.secrets.tailscale.path;

  # services.samba.settings.public = {
  #   path = "/yeah";
  #   browseable = "yes";
  #   "read only" = "no";
  #   "guest ok" = "yes";
  #   "create mask" = "0644";
  #   "directory mask" = "0755";
  #   # "force user" = "guest";
  #   # "force group" = "groupname";
  # };

  networking.hostName = lib.mkDefault "Namaku1801"; # Define your hostname.
  networking.hostId = lib.mkDefault "4970ef8d"; # required for zfs
  # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # enable NAT for wireguard
  networking.nat.enable = lib.mkIf config.networking.wireguard.enable true;
  networking.nat.externalInterface = config.data.nat-outInterface or "wlp3s0";
  networking.nat.internalInterfaces = builtins.attrNames config.networking.wireguard.interfaces;

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.git.enable = true;

  programs.fish.shellAbbrs."non" = /* fish */ ''doas nvim +"tcd /etc/nixos"'';

  programs.cloudflared = {
    enable = true;
    secretFile = config.age.secrets.cloudflared.path;
  };

  # allow fuse in user mode
  programs.fuse.userAllowOther = true;

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Add list DE/WM to login manager
  services.windowManager = {
    sway.enable = true;
    niri.enable = true;
  };
}
