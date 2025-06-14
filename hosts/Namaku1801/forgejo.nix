{ config, lib, ... }:
{
  services.forgejo = {
    enable = true;
    lfs.enable = true;
    settings = {
      DEFAULT = {
        RUN_MODE = "dev";
        APP_NAME = "ForGejo(h)";
      };
      server.ROOT_URL = "https://forgejo.local/";
    };
  };

  services.certs = {
    forgejo.cname = "forgejo.local";
    forgejo.alts = [ "DNS:forgejo.local" "DNS:www.forgejo.local" ];
  };

  services.caddy.virtualHosts = {
    "https://forgejo.local" = lib.mkIf config.services.forgejo.enable {
      serverAliases = [ "www.forgejo.local" ];
      extraConfig = with config.services; /* caddy */ ''
        tls ${certs.forgejo.cert} ${certs.forgejo.key}
        log {
          format console
          output stdout
        }
        reverse_proxy localhost:${toString forgejo.settings.server.HTTP_PORT}
      '';
    };
  };
}
