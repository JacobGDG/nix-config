{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}:
    lib.mkIf pkgs.stdenv.isLinux {
      packages = lib.mapAttrs' (hostname: nixos:
        lib.nameValuePair "vm-${hostname}" (pkgs.writeShellApplication {
          name = "vm-${hostname}";
          text = ''
            ${nixos.config.system.build.vm}/bin/run-${hostname}-vm "$@"
          '';
        }))
      inputs.self.nixosConfigurations;
    };
}
