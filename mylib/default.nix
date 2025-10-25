{lib, ...}: {
  relativeToRoot = lib.path.append ../.;
  homeManagerModules = lib.path.append ../modules/home-manager;
  nixosModules = lib.path.append ../modules/nixos;

  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)));

  mkEnableOptionWithDefault = name: default:
    lib.mkOption {
      default = default;
      example = true;
      description = "Whether to enable ${name}.";
      type = lib.types.bool;
    };
}
