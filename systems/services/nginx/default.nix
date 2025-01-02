{ config, pkgs, ... }:
{
  enable = ! config.services.caddy.enable && ! config.data.isMinimal or false;
  recommendedProxySettings = true;
  recommendedTlsSettings = true;
  package = pkgs.nginxStable.override {
    openssl = pkgs.libressl;
  };
}
