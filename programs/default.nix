{ pkgs
, lib
, config
, inputs
, ...
} @ variables
: let
  inherit (lib.fmway)
    customImport
    genImportsWithDefault
  ;
in {
  imports = genImportsWithDefault ./.;

  nixpkgs.config = {

    # Allow unfree packages
    allowUnfree = true;
    # or
    # allowUnfreePredicate = pkg:
    #   builtins.elem (lib.getName pkg) [
    #     "genymotion"
    #     "spotify"
    #   ];

    # allow insecure packages
    permittedInsecurePackages = [
      "python3.12-youtube-dl-2021.12.17"
    ] ++ (inputs.fmpkgs.nixConfig.permittedInsecurePackages or []);
  };

  # List packages installed in the system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    # cloudflare-warp
    scrcpy
    wl-clipboard
    google-authenticator
  ]);

  environment.excludePackages = with pkgs; [
  ];

  # Exclude packages from the X server.
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  # Exclude packages from the gnome.
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-maps
    geary
    gnome-tour
    # gnome-software
    gnome-contacts
  ];


  programs = customImport
  { 
    # Some programs need SUID wrappers, can be configured further or are started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # nh is nixos-rebuild / nix build with beautiful output
    nh = {
      enable = lib.mkDefault true;
      flake = "/etc/nixos";
    };

    # allow fuse in user mode
    fuse.userAllowOther = true;

    # enable cloudflared
    cloudflared = {
      enable = lib.mkDefault true;
      secretFile = config.age.secrets.cloudflared.path;
    };

    # enable scripts
    script.enable = true;
    script.cwd = ./scripts;
    
  }
  {
    folder = [ ./cli ./gui ./games ];
    inherit variables;
  };
}
