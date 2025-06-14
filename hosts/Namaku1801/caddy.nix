{ config, lib, ... }: let
  inherit (config.services) fcgiwrap certs;
in {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "https://cgi.local.com".extraConfig = ''
        tls ${certs.cgi.cert} ${certs.cgi.key}
        log {
          format console
          output stdout
        }
        header {
          Access-Control-Allow-Headers *
          Access-Control-Allow-Methods *
          Access-Control-Allow-Origin *
        }
        @options {
          method OPTIONS
        }
        respond @options 204
        handle_path /static/* {
          root * /srv/static
          file_server
        }
        handle {
          root * /srv/cgi
          try_files {path} {path}/index.cgi {path}/index {path}.cgi 404 404.cgi
          reverse_proxy unix/${fcgiwrap.instances.fmway.socket.address} {
            transport fastcgi {
              env PATH ${lib.fmway.printPathv1 config "fmway"}
              split .cgi
            }
          }
        }
      '';
    };
  };

  services.fcgiwrap.instances = lib.mkIf config.services.caddy.enable {
    fmway = {
      socket = {
        group = config.services.caddy.group;
        user = config.users.users.fmway.name;
        mode = "0666";
      };
      process = {
        user = config.users.users.fmway.name;
        group = config.users.groups.users.name;
      };
    };
  };

  services.certs = {
    cgi.cname = "cgi.local.com";
    cgi.alts = [ "DNS:cgi.local.com" ];
  };
}
