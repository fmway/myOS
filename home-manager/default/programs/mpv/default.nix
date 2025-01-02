{ config, ... }:
{
  enable = ! config.data.isMinimal or false;
  config = {};
  bindings = {};
}
