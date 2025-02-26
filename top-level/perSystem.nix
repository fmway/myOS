{ pkgs, lib, ... }: {
  apps = {
    # generate stubby certs
    updateStubbyCert = {
      type = "app";
      program = pkgs.writeScriptBin "update-stubby-cert.fish" /* fish */ ''
        #!${lib.getExe pkgs.fish}
        ${lib.fmway.mkFishPath (with pkgs; [
          jq
          knot-dns
          gnugrep
          gnused
        ])}

        set tmp_json "$(cat ./systems/services/stubby/__dns.json)"
        #
        for i in (echo "$tmp_json" | jq -r 'keys_unsorted[]')
          set tls_host "$(echo "$tmp_json" | jq -r '."'$i'".tls_host')"
          set oldCert "$(echo "$tmp_json" | jq -r '."'$i'".signedCert')"
          
          set newCert "$(kdig -d @$i +tls-ca +tls-host=$tls_host example.com 2>/dev/null | grep '#1,' -A 1 | tail -n1 | sed 's/.\+ PIN: \(.\+\)/\1/')"

          if [ $oldCert != $newCert ]
            echo "$tmp_json" | jq '."'$i'".signedCert = "'$newCert'"' > ./systems/services/stubby/__dns.json
            set tmp_json "$(cat ./systems/services/stubby/__dns.json)"
          end
        end
      '';
    };
    # generate cachix on nix.conf
    gcn = {
      type = "app";
      program = let
        option = lib.mkOption { type = with lib.types; listOf str; default = []; };
        inherit ((lib.evalModules {
          modules = [
            { options.nix.settings = lib.listToAttrs (
                map (name: { inherit name; value = option; }) [
                  "trusted-public-keys" "experimental-features" "substituters"
            ]); }
            { nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ]; }
            { nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ]; }
            ../cachix.nix
          ];
          specialArgs = { inherit pkgs lib; };
        }).config.nix) settings;
      in pkgs.writeScriptBin "gen-nix-conf.sh" /* sh */ ''
        #!${lib.getExe pkgs.bash}

        ${lib.attrNames settings |> map (x: /* sh */ ''
          echo ${x} = ${lib.concatStringsSep " " settings.${x}};
        '') |> lib.concatStringsSep ""}
      '';
    };
  };
}
