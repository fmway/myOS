{ pkgs
, lib
, config
, ...
}
@ variables
:
let
  inherit (lib.fmway)
    treeImport
    matchers
    genTreeImports
  ;
in treeImport {
  imports = genTreeImports ./extra;

  zramSwap.enable = lib.mkDefault true;
  zramSwap.swapDevices = lib.mkDefault 8;
  zramSwap.memoryMax = lib.mkDefault 1073741824; # 1GB per devices
}
{
  excludes = [
    "extra"
    # "boot/loader/grub"
    # "services/nginx"
    # "services/phpfpm"
    "networking/wg-quick"
    "networking/wireguard"
    "systemd/services"
    # "services/stubby"
  ];

  includes = with matchers; [
    (extension "conf")
    (extension "txt")
    json
  ];

  # auto-enable = [
  #   ["services"] # services.*.enable = true;
  # ];

  folder = ./.;
  inherit variables;
}
