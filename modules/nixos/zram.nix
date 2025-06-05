{ lib, ... }:
{
  zramSwap.enable = lib.mkDefault true;
  zramSwap.swapDevices = lib.mkDefault 4;
  zramSwap.memoryMax = lib.mkDefault 2147483648; # 2GB per devices
}
