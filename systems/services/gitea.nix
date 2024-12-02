{ config, ... }: {
  enable = ! (config.data.isMinimal or false);
  appName = "My Git (eaaa)";
  lfs.enable = true; # enable git lfs
  settings = {
    server.ROOT_URL = "https://gitea.local/";
  };
}
