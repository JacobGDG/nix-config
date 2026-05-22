{
  lib,
  config,
  ...
}: {
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
  };

  config = let
    predicate = let
      allowed = config.nixpkgs.allowedUnfreePackages;
    in
      pkg: builtins.elem (lib.getName pkg) allowed;
  in {
    flake.modules.nixos.core.nixpkgs.config.allowUnfreePredicate = predicate;
    flake.modules.homeManager.core.nixpkgs.config.allowUnfreePredicate = predicate;
  };
}
