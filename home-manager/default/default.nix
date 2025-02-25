{ pkgs
, lib
, root-path
, config
, ...
} @ variables
: let
  inherit (pkgs.functions)
    getEnv
    genPaths
  ;
  inherit (config.home) homeDirectory username;

  homeImports = let
    exclusive = [ "catppuccin" "dconf" ];
    result = lib.fmway.getNixs ./. |> map (file: let
      name = lib.removeSuffix ".nix" file;   
      path = lib.optionals (lib.all (x: x != name) exclusive) [ "home" ] ++ [ name ];
      res  = let
        imported = import (./. + "/${file}");
      in if builtins.isFunction imported then imported variables else imported;
    in (lib.setAttrByPath path res));
  in { config = lib.mkMerge result; };
in
{
  imports = [
    ./desktop
    homeImports
  ];

  programs.home-manager.enable = true;

  home = {
    # Home Manager version
    stateVersion = lib.mkDefault (
      if variables ? osConfig then
        variables.osConfig.system.stateVersion
      else
        lib.fileContents "${root-path}/.version"
    );

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
      # auto-enable = false;
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
