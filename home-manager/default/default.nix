{ pkgs
, lib
, options
, config
, nixosConfig
, ...
} @ variables
: let
  inherit (pkgs.functions)
    getEnv
    genPaths
  ;
  inherit (config.home) homeDirectory username;
in
{
  imports = [
    ./desktop
    {
      options.home.dconf = options.dconf;
      config.dconf = config.home.dconf;
    }
    {
      options.home.catppuccin = options.catppuccin;
      config.catppuccin = config.home.catppuccin;
    }
    (let
      nixs = lib.fmway.getNixs ./.;
      result = map (file: {
        name = lib.removeSuffix ".nix" file;   
        value = let
          imported = import (./. + "/${file}");
        in if builtins.isFunction imported then imported variables else imported;
      }) nixs;
    in {
      home = lib.listToAttrs result;
    })
  ];

  programs.home-manager.enable = true;

  home = {
    # Home Manager version
    stateVersion = lib.mkDefault (nixosConfig.system.stateVersion);

    sessionPath = genPaths homeDirectory [
      ".local" # must be ${home}/.local/bin
      ".cargo" # etc
      ".deno"
      ".bun"
      ".foundry"
    ];

    sessionVariables = rec {
      ASSETS = "${homeDirectory}/assets";
      ASET = "${homeDirectory}/aset";
      GITHUB = "${ASET}/Github";
      DOWNLOADS = "${homeDirectory}/Downloads";
    } // (getEnv username);

    # xkb options
    keyboard.options = [
      "grp:shifts_toggle"
      "caps:none" # disable capslock
    ];
  };

  # nix.extraOptions = ''
    # extra-experimental-features = nix-command flakes
  # '';

  services = {
    clipman.enable = true; # clipboard manager
    clipman.systemdTarget = "sway-session.target";
  };

  features = {
    # $HOME/.config refers to ./configs
    config.enable = true;
    config.cwd = ./configs;

    programs.auto-import = {
      enable = true;
      cwd = ./programs;
      auto-enable = true;
      includes = let
        inherit (lib.fmway.matchers) extension json;
      in [
        (extension "fish")
        (extension "css")
        (extension "conf")
        (extension "tmux")
        (extension "sh")
        json
      ];
    };

    # install collection of scripts in ./scripts
    script.enable = true;
    script.cwd = ./scripts;
  };
}
