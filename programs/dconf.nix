{ lib, pkgs, ... }: let
  # parse normal attrs to dconf familiar
  dconfFamiliar = obj: let
    func = prefix: obj:
      lib.foldl' (res: x: let
        value = obj.${x};
      in res // (if (lib.isAttrs value && ! value ? __toString) then
        func (prefix ++ [ x ]) value
      else let
        key = lib.concatStringsSep "." prefix;
      in  {
        ${key} = (res.${key} or {}) // { ${x} = toString (with lib.hm.gvariant;
          if lib.isList value then
            mkArray type.string value
          else if lib.isBool value then
            mkBoolean value
          else if lib.isString value then
            mkString value
          else value);
        };
      })) {} (lib.attrNames obj);
      res = func [] obj;
  in lib.concatStringsSep "\n" (lib.flatten (map (x:
    ["[${x}]"] ++ map (y:
      "${y}=${res.${x}.${y}}"
    ) (lib.attrNames res.${x})
  ) (lib.attrNames res))) + "\n";

  keybindings = l: # list of { name ::: string, binding ::: string, command ::: string }
    lib.listToAttrs (lib.lists.imap0 (i: v: let
      name = "custom${toString i}";
    in {
      inherit name;
      value = with lib.gvariant; {
        name = mkString (v.name or name);
        binding = mkString v.binding;
        command = mkString "${v.command}";
      };
    }) l);
  parse = x: {
    services.xserver.desktopManager.gnome.extraGSettingsOverrides = let
      kb = keybindings (x.keybindings or []);
    in dconfFamiliar (x.config or {}) + lib.optionalString (x.keybindings or [] != []) (''
    [org.gnome.settings-daemon.plugins.media-keys]
    custom-keybindings=[${lib.concatStringsSep "," (map (x:
        "'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${x}/'"
      ) (lib.attrNames kb)
    )}]
    '' + dconfFamiliar {
      org.gnome.settings-daemon.plugins.media-keys.custom-keybindings = kb;
    });
  };
in parse {
  config = {
    org.gnome.desktop.peripherals.touchpad = {
      tap-to-click = true;
    };
    org.gnome.shell = {
      disable-user-extensions = false;
      enabled-extensions = map (x:
        if builtins.isString x then
          x
        else x.extensionUuid)
      (with pkgs.gnomeExtensions; [
        blur-my-shell
        gsconnect
        paperwm
        appindicator
        clipboard-indicator
        thinkpad-battery-threshold
        blur-my-shell
        # net-speed
        totp
        # cloudflare-warp-toggle
        system-monitor
        weather-oclock
        # bing-wallpaper-changer
        places-status-indicator
        applications-menu
        emoji-copy
        day-progress
        lilypad
      ]);

      # extensions settings in ./__extensions
      extensions.clipboard-indicator = {
        cache-images = true;
        cache-size = 1024; #MB
        history-size = 10000;
        preview-size = 100;
        topbar-preview-size = 10;

        confirm-clear = true;
        disable-down-arrow = true;
        notify-on-copy = true;
        strip-text = true; # auto trim
        # toggle-menu = true;
        # keep-selected-on-clear = true;
        # move-item-first = true;

        # keybinds
        enable-keybindings = true;
        # clear-history = ["<>"];
        # next-entry = ["<>"];
        # prev-entry = ["<>"];
        # private-mode-binding = ["<>"];
      };
      extensions.day-progress = {
        width = 15;
        height = 9;
        show-elapsed = false;
        style = 1; # bar, circular bar, pie with border, pie (0, 1, 2, 3)
        panel-position = 2; # left, middle, right (0, 1, 2)
        panel-index = 1;
        reset-hour = 0;
        reset-minute = 0;
        start-hour = 0;
        start-minute = 0;
      };

      extensions.emoji-copy = with lib.hm.gvariant; {
        active-keybind = mkBoolean true;
        always-show = mkBoolean false;
        paste-on-select = mkBoolean true;
        emoji-keybind = mkArray type.string ["<Super>colon"];
      };

      extensions.lilypad = {
        rightbox-order = [
          "Day_Progress"
          "system_monitor"
          "lilypad"
        ];
        lilypad-order = [
          "steam"
          "StatusNotifierItem"
          # "BingWallpaperIndicator"
          "emoji_copy"
          "totp"
          "clipboardIndicator"
        ];

        # ignore-order = [];
      };

      extensions.paperwm = {
        default-focus-mode = 0;
        open-window-position = 0; # right
        keybindings.toggle-scratch = [ "<Shift><Super>space" ];
        show-workspace-indicator = false; # if false = indicator pills
      };

      extensions.system-monitor = {
        show-cpu = true;
        show-download = true;
        show-memory = true;
        show-upload = true;
        show-swap = false;
      };
    };

    org.gnome.desktop = {
      interface = {
        color-scheme = "prefer-dark"; # dark mode
        cursor-theme = "Adwaita";
        cursor-size = 50;
        icon-theme = "Adwaita";
        gtk-theme = "adw-gtk3";
      };

      # Change background
      # background = {
      #   picture-uri = "file:///<path>";
      #   picture-uri-dark = "file:///<path>";
      # };
    };
  };

  keybindings = let
    bash = name: script:
      pkgs.writeScript name ''
        #!${lib.getExe pkgs.bash}

        ${script}
      '';
  in [
    {
      name = "increment cursor size";
      binding = "<Alt><Super>equal";
      command = bash "increment-cursor" /* sh */ ''
        CURRENT=$(gsettings get org.gnome.desktop.interface cursor-size)
        gsettings set org.gnome.desktop.interface cursor-size $(( CURRENT + 1 ))
      '';
    }
    {
      name = "decrement cursor size";
      binding = "<Alt><Super>minus";
      command = bash "decrement-cursor" /* sh */ ''
        CURRENT=$(gsettings get org.gnome.desktop.interface cursor-size)
        [ ! -z $CURRENT ] &&
          [ $CURRENT -ge 1 ] &&
          gsettings set org.gnome.desktop.interface cursor-size $(( CURRENT - 1 ))
      '';
    }
  ];
}
