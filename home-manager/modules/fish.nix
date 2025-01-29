{ config, lib, ... }: let
  cfg = config.programs.fish;
  bindsModule = lib.types.submodule { options = {
    enable = lib.mkEnableOption "enable binds" // { default = true; };
    mode = lib.mkOption {
      description = "Specify the bind mode that the bind is used in";
      type = with lib.types; nullOr (enum [ "default" "insert" "paste" ]);
      default = null;
    };
    command = lib.mkOption {
      type = lib.types.str;
    };
    setsMode = lib.mkOption {
      description = "Change current mode after bind is executed";
      type = with lib.types; nullOr (enum [ "default" "insert" "paste" ]);
      default = null;
    };
    erase = lib.mkEnableOption "remove bind";
    silent = lib.mkEnableOption "Operate silently";
    operate = lib.mkOption {
      description = "Operate on preset bindings or user bindings";
      type = with lib.types; nullOr (enum [ "preset" "user" ]);
      default = null;
    };
  }; };

  filtered = lib.filter (x: cfg.binds.${x}.enable) (lib.attrNames cfg.binds);

  generated = map (key: let
    self = cfg.binds.${key};
    opts = lib.optionals self.silent ["-s"] ++
      (if self.erase then
        ["-e"]
      else
        lib.optionals (!isNull self.operate) ["--${self.operate}"] ++
        lib.optionals (!isNull self.mode) ["--mode" self.mode] ++
        lib.optionals (!isNull self.setsMode) ["--sets-mode" self.setsMode]
      );
  in lib.concatStringsSep " " (["bind"] ++ opts ++ [ key (lib.escapeShellArg self.command) ])) filtered;

  result = lib.concatStringsSep "\n" generated;
in {
  options.programs.fish.binds = lib.mkOption {
    type = lib.types.attrsOf bindsModule;
    default = {};
  };
  config = lib.mkIf cfg.enable {
    programs.fish.functions.fish_user_key_bindings = lib.mkIf (lib.length filtered > 0) result;
  };
} 
