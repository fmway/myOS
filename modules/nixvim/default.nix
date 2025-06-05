{ internal, _file, allModules, inputs, ... }:
{ ... }:
{
  inherit _file;
  imports = allModules;
  luaLoader.enable = true;
  dependencies.gcc.enable = true;

  # add some filetype alias
  filetype.filename = {
    "build.zig.zon" = "zig";
  };
  filetype.pattern = {
    ".*%.blade%.php" = "blade";
    ".*/ghostty/config" = "toml";
    ".*/ghostty/themes/.*%.conf" = "dosini";
    ".*/zed/.*%.json" = "jsonc";
  };
}
