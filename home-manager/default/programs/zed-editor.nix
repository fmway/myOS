{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    rust-analyzer
    gopls
  ];

  userSettings = {
    ui_font_size = 16;
    buffer_font_size = 16;
    vim_mode = true;
    auto_update = false;
    relative_line_numbers = true;

    lsp = {
      rust-analyzer.initialization_options = {
        snippets = {
          "Arc::new" = {
            "postfix" = "arc";
            "body" = ["Arc::new(\${receiver})"];
            "requires" = "std::sync::Arc";
            "scope" = "expr";
          };
          "Some" = {
            "postfix" = "some";
            "body" = ["Some(\${receiver})"];
            "scope" = "expr";
          };
          "Ok" = {
            "postfix" = "ok";
            "body" = ["Ok(\${receiver})"];
            "scope" = "expr";
          };
        };
        rust.analyzerTargetDir = true;
        check.command = "clippy";
      };
    };
  };

  extensions = [ "nix" ];
}
