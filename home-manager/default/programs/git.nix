{ pkgs, lib, ... }:
{
  userName = "fmway";
  userEmail = "fm18lv@gmail.com";
  # delta.enable = true; # enable git diff with delta
  # difftastic.enable = true; # git diff with difftastic
  # diff-so-fancy.enable = true; # git diff with diff-so-fancy
  signing.format = "ssh";
  aliases = {
    a = "add";
    cm = "commit";
    ch = "checkout";
    s = "status";
  };
  extraConfig = {
    hub.protocol = "ssh";
    url = let
      init = {
        "git@github.com:fmway/".insteadOf = "fmway:";
      };
      sites = {
        "github.com" = "gh" ;
        "gitlab.com" = "gl";
        "codeberg.org" = "cb";
      };
    in lib.pipe sites [
      (lib.attrNames)
      (lib.foldl' (acc: x: acc // {
        "https://${x}/".insteadOf = "${sites.${x}}:";
        "git@${x}:".insteadOf = "${sites.${x}}s:";
      }) init)
    ];
    # credential.helper = "${
    #   pkgs.custom.git
    # }/bin/git-credential-libsecret";
  };
}
