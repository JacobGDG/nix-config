{
  lib,
  config,
  ...
}: {
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
  };

  config = {
    flake.modules.nixos.core.nixpkgs.config.allowUnfreePredicate = let
      allowed = config.nixpkgs.allowedUnfreePackages;
    in
      pkg: builtins.elem (lib.getName pkg) allowed;
  };
}
