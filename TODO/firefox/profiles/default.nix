{ config, namaku, lib, ... }:
let
  key = [ (config.data.firefoxProfileName or "namaku") ];
in lib.setAttrByPath key namaku
