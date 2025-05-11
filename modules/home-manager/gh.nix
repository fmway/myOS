{ lib, ... }:
{
  # github-cli
  programs.gh.enable = lib.mkDefault true;
  programs.gh.settings = {
    editor = "nvim";
    aliases = {
      co = "pr checkout";
      pv = "pr view";
    };
    git_protocol = "ssh";
  };
  # github-cli dashboard
  programs.gh-dash.enable = lib.mkDefault true;
  programs.gh-dash.settings = {
    prSections = [{
      title = "My Pull Requests";
      filters = "is:open author:@me";
    }];
  };
}
