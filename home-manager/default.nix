{ pkgs, inputs, lib, ... }:
{
  imports = [
    ./fish
    ./starship.nix
#    inputs.nvchad.nixosModules.default
#    ({ lib, ... }: {
#      programs.nixvim.imports = [ ./nvchad ];
#      programs.nixvim.enable = true;
#      programs.neovim.enable = lib.mkForce false;
#    })
    ./git.nix
    ./lazygit.nix
    ./fzf.nix
    ./fonts.nix
    ./vim.nix
    ./tmux
  ];

  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  programs = {
    home-manager.enable = true; 
    bat.enable = true; # cat alternative
    bat.config = {
      pager = "less -FR";
    };

    # ls alternative
    eza.enable = true;
    eza.icons = "auto"; # display icons
    eza.git = true; # git integration

    jq.enable = true;

    zoxide.enable = true; # cd alternative

  };

  home.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    # vim # or some other editor, e.g. nano or neovim
    neovim
    nano
    # Some common stuff that people expect to have
    procps
    killall
    openssh
    diffutils
    findutils
    fd # findutils alternative
    utillinux
    cloudflared
    #tzdata
    hostname
    man
    gnugrep
    #gnupg
    gnused
    gnutar
    #bzip2
    #gzip
    #xz
    zip
    unzip
  ];
}
