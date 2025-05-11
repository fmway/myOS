{ lib, ... }:
{
  _file = ./swap.nix;
  zramSwap.enable = lib.mkDefault true;
  zramSwap.swapDevices = lib.mkDefault 8;
  zramSwap.memoryMax = lib.mkDefault 1073741824; # 1GB per devices
}
