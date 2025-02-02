{ config, lib, ... }:
{
  "${config.data.defaultUser}" = lib.mkIf (config.services.caddy.enable && ! config.data.isMinimal or false) {
    socket = {
      group = config.services.caddy.group;
      user = config.users.users.${config.data.defaultUser}.name;
      mode = "0666";
    };
    process = {
      user = config.users.users.${config.data.defaultUser}.name;
      group = config.users.groups.users.name;
    };
  };
}
