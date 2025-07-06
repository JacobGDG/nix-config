{
  config,
  lib,
  ...
}: {
  options.myModules.common = {
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable common desktop applications and settings, also state lack of battery management.";
    };
  };
}
