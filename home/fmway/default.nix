{ internal, config, self, lib, ... } @ x:
{ config, inputs, osConfig ? {}, ... } @ y: let
  cfg = config.home;
in {
  imports = [
    ./packages.nix
    ./configs
    ./fish.nix
    ./floorp
    (self.homeManagerModules.defaultWithout [
      "hyprland"
      "firefox"
    ])
  ];
  home = {
    username = "fmway";
    homeDirectory = "/home/fmway";
    sessionPath = map (x: "${cfg.homeDirectory}/${x}/bin") [
      ".local" # must be ${home}/.local/bin
      ".cargo" # etc
      ".deno"
      ".bun"
      ".foundry"
    ];

    sessionVariables = rec {
      ASSETS = "${cfg.homeDirectory}/assets";
      ASET = "${cfg.homeDirectory}/aset";
      GITHUB = "${ASET}/Github";
      DOWNLOADS = "${cfg.homeDirectory}/Downloads";
    } // lib.optionalAttrs (lib.pathExists "${inputs.self.outPath}/secrets/${cfg.username}.env")
      (lib.fmway.readEnv "${inputs.self.outPath}/secrets/${cfg.username}.env");

    # xkb options
    keyboard.options = [
      "grp:shifts_toggle"
      "caps:none" # disable capslock
    ];
  };
  programs.git = {
    userName = "fmway";
    userEmail = "fm18lv@gmail.com";
    extraConfig = {
      url."git@github.com:fmway/".insteadOf = "fmway:";
    };
  };
}
