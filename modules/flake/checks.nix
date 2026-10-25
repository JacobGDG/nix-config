{
  inputs,
  lib,
  ...
}: {
  # Build every host and home configuration for the current system, so
  # `nix flake check` proves the whole fleet still builds
  perSystem = {system, ...}: let
    forSystem = lib.filterAttrs (_: cfg: cfg.pkgs.stdenv.hostPlatform.system == system);
  in {
    checks =
      lib.mapAttrs' (name: nixos: lib.nameValuePair "nixos-${name}" nixos.config.system.build.toplevel)
      (forSystem inputs.self.nixosConfigurations)
      // lib.mapAttrs' (name: home: lib.nameValuePair "home-${name}" home.activationPackage)
      (forSystem inputs.self.homeConfigurations);
  };
}
