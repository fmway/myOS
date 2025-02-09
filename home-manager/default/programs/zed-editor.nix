{ pkgs, lib, ... }:
{
  package = pkgs.zed-editor_git;
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
    # calls.mute_on_join = false;

    # Only deno for ts / typescript 😏
    languages = [ "TypeScript" "TSX" ] |> map (name: {
      inherit name;
      value.language_servers = [
        "deno"
        "!typescript-language-server"
        "!vtsls"
        "!eslint"
      ];
      value.formatter = "language_server";
    }) |> builtins.listToAttrs;

    lsp = {
      deno.settings.deno.enable = true;
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

  userKeymaps = [
    # insert mode
    {
      context = "Editor && vim_mode = insert && !menu";
      bindings = {
      };
    }
    # visual / normal mode
    {
      context = "Editor && (vim_mode == insert || vim_mode == normal) && vim_mode != waiting && !menu";
      bindings = {
        ";" = "command_pallete::Toggle"; # same as :
        "ctrl-n" = "project_panel::ToggleFocus";
      };
    }
    {
      context = "not_editing && ProjectPanel";
      bindings."ctrl-n" = "workspace::ToggleLeftDock";
    }
  ];

  extensions = [ "nix" "deno" ];
}
