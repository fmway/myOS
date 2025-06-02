{ internal, lib, ... }: let
  genAfter = cfg:
    lib.concatStringsSep "\n" (
      map (x: cfg.luaConfig.${x}) (lib.filter (x:
        !isNull cfg.luaConfig.${x}
      ) [ "pre" "content" "post" ])
    );
in { config, ... }:
{
  config = lib.mkMerge [
    {
      opts = {
        guifont = "JetBrainsMono Nerd Font:h14";
      };
      globals = {
        neovide_cursor_vfx_mode = [
          "railgun"
          # "sonicboom"
        ];
        neovide_cursor_antialiasing = false;
        # neovide_fullscreen = true;
        neovide_no_idle = false;
      };
    }
    (lib.mkIf config.plugins.neoscroll.enable {
      plugins.neoscroll.settings.performance_mode = true;
      plugins.neoscroll = {
        lazyLoad.settings.after = lib.nixvim.mkRawFn ''
          if not vim.g.neovide then
            ${lib.fmway.addIndent' "  " (genAfter config.plugins.neoscroll)}
            --
          end
        '';
      };
    })
    (lib.mkIf config.plugins.smear-cursor.enable {
      plugins.smear-cursor.lazyLoad.settings.after = lib.nixvim.mkRawFn ''
        --
        if not vim.g.neovide then
          ${lib.fmway.addIndent' "  " (genAfter config.plugins.smear-cursor)}
          --
        end
      '';
    })
  ];
}
