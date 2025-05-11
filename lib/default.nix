{ lib, ... }:
{
  mkFishPath = pkgs:
    lib.pipe pkgs [
      (lib.makeBinPath)
      (lib.splitString ":")
      (map (x: "fish_add_path ${x}"))
      (lib.concatStringsSep "\n")
    ];

  genUser = name: assert lib.isString name; args @ {
    description ? name,
    isNormalUser ? true,
    home ? "/home/${name}",
    extraGroups ? [
      "networkmanager"
      "docker"
      "wheel"
      "video"
      "gdm"
      "dialout"
      "kvm"
      "adbusers"
      "vboxusers"
      "fwupd-refresh"
    ],
    ...
  }: assert (
    lib.isString description &&
    lib.isBool isNormalUser &&
    lib.isString home &&
    lib.isList extraGroups &&
    lib.all lib.isString extraGroups
  ); {
    ${name} = args // {
      inherit description isNormalUser home extraGroups;
    };
  };

  # users :: lists, options :: ( attrs | str -> attrs )
  genUsers = users: options:
    assert (
      lib.isList users &&
      lib.length users != 0 &&
      lib.all lib.isString users &&
      (lib.isAttrs options || (lib.isFunction options && lib.isAttrs (options "test")))
    );
    lib.foldl' (acc: name: let
      opts = if lib.isAttrs options then options else options name;
    in  acc // lib.genUser name opts) {} users;
}
