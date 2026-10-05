{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nix-config";
      packages = with pkgs; [
        git
        home-manager
        just

        nil
        alejandra
        nvd
      ];
    };
  };
}
