{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nix-config";
      packages = with pkgs; [
        nil
        alejandra
        nvd
      ];
    };
  };
}
