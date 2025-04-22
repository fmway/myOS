{ pkgs
, lib
, config
, ... }
@ variables
:
let
  inherit (lib.fmway)
    matchers
    treeImport
  ;
  x = lib.fmway.treeImport {
    folder = ./.;
    includes = with matchers; [
      (extension "conf")
      (filename "config")
    ];
    inherit variables;
  };
in {
  config = lib.mkIf (! config.data.isMinimal or false) {
  # import all in folder ./wayland to wayland.windowManager
  wayland.windowManager = x.wayland;

  # import all in folder ./x to xsession.windowManager
  xsession.windowManager = x.x;
}; }
