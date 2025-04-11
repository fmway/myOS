{ pkgs, dns, lib, ... }: let
  extract_dns = lib.pipe dns [
    (lib.attrNames)
    (lib.foldl' (acc: curr: let
      tls_auth_name = dns.${curr}.tls_name;
      tls_pubkey_pinset = map (x: { value = x; digest = "sha256"; }) (lib.flatten [ dns.${curr}.signedCert ]);
      toValue = x: {
        inherit tls_pubkey_pinset tls_auth_name;
        address_data = x;
      };
      alts = map toValue (lib.flatten [ dns.${curr}.alt ]);
    in acc ++ [ (toValue curr) ] ++ lib.optionals (dns.${curr}.alt or [] != []) alts) [])
  ];
in {
  enable = true;
  settings =
    pkgs.stubby.passthru.settingsExample // { upstream_recursive_servers = extract_dns; };
}
