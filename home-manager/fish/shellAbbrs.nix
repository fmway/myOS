{ config, lib, ... }:
let
  with-cursor = str: {
    setCursor = "!";
    expansion = "${str}";
  };
in { programs.fish.shellAbbrs = {
  "lg" = "lazygit";

  "y1080"= "yt-dlp -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]'";
  "y720" = "yt-dlp -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'";
  "y480" = "yt-dlp -f 'bestvideo[height<=480]+bestaudio/best[height<=480]'";
  "y360" = "yt-dlp -f 'bestvideo[height<=360]+bestaudio/best[height<=360]'";
  "ytp"  = "yt-dlp --yes-playlist -o \"%(playlist)s/%(playlist_index)s. %(title)s.%(ext)s\" -f 'bestvideo[height<=480]+bestaudio/best[height<=480]'";
  "ytplaylist" = "yt-dlp --output '%(playlist_title)s/%(playlist_index)s. %(title)s.%(ext)s'";
  "m3v"  = "mpv --no-video";

  "nos" = "nix-on-droid switch --verbose --flake ~/.config/nix-on-droid";
  "nob" = "nix-on-droid build --verbose --flake ~/.config/nix-on-droid";
  "nor" = "nix-on-droid rollback --verbose --flake ~/.config/nix-on-droid";
  "nofu"  = "nix flake update --flake ~/.config/nix-on-droid";
  "nfu"   = "nix flake update";
  "nofl"  = "nix flake lock ~/.config/nix-on-droid";
  "nfl"   = "nix flake lock";
  "nfit"  = "nix flake init --template";
  "nfi"   = "nix flake init";

  "gclg"   = with-cursor "git clone https://github.com/!";
  "gclgl"  = with-cursor "git clone https://gitlab.com/!";
  "gclc"   = with-cursor "git clone https://codeberg.org/!";
  "gclsg"  = with-cursor "git clone git@github.com:!";
  "gcls"   = with-cursor "git clone git@!";
  "gclsgl" = with-cursor "git clone git@gitlab.com:!";
  "gclsc"  = with-cursor "git clone git@codeberg.org:!";
}; }
