{
  inputs,
  lib,
  ...
}: {
  options.myModules.common = {
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "whether to enable common desktop applications and settings, also state lack of battery management.";
    };
    wallpaper = lib.mkOption {
      type = lib.types.string;
      default = "${inputs.wallpapers}/nature/haystacks.jpg";
      description = "Wallpaper to use for desktop, lockscreen etc";
    };
  };
}
