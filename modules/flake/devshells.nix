{config, ...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nix-config";
      packages = with pkgs; [
        git
        home-manager
        just
        (config.flake-file.tack.package pkgs)
        (config.flake-file.apps.write-lock pkgs)

        nil
        alejandra
        nvd
        prettier
      ];
    };
  };
}
