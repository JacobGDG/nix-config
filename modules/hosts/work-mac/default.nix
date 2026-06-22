{
  # https://github.com/hraban/mac-app-util/issues/42
  # nixpkgs pin removed due to above issue
  flake-file.inputs.mac-app-util.url = "github:hraban/mac-app-util";

  hosts."MacBook-Pro.local".system = "aarch64-darwin";

  flake.modules.homeManager."MacBook-Pro.local" = {
    pkgs,
    inputs,
    ...
  }: {
    imports = [
      inputs.mac-app-util.homeManagerModules.default
    ];

    xdg.configFile."nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';

    home = {
      sessionPath = [
        "/nix/var/nix/profiles/default/bin"
        "/opt/homebrew/bin"
      ];
    };
  };
}
