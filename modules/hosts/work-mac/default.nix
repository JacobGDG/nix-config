{
  flake-file.inputs.mac-app-util = {
    url = "github:hraban/mac-app-util";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.cl-nix-lite.inputs.nixpkgs.follows = "nixpkgs";
    inputs.cl-nix-lite.inputs.treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    inputs.treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  hosts.work-mac.system = "aarch64-darwin";

  flake.modules.homeManager.work-mac = {
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
