{ pkgs, dns, lib, ... }: let
  inherit (builtins) attrNames foldl';
  extract_dns = attrNames dns |> foldl' (acc: curr: let
    tls_auth_name = dns.${curr}.tls_name;
    tls_pubkey_pinset = lib.flatten [ dns.${curr}.signedCert ] |> map (x: { value = x; digest = "sha256"; });
    toValue = x: {
      inherit tls_pubkey_pinset tls_auth_name;
      address_data = x;
    };
    alts = lib.flatten [ dns.${curr}.alt ] |> map (x: toValue x);
  in acc ++ [ (toValue curr) ] ++ lib.optionals (dns.${curr}.alt or [] != []) alts) [];
in {
  enable = true;
  settings =
    pkgs.stubby.passthru.settingsExample // { upstream_recursive_servers = extract_dns; };
}
