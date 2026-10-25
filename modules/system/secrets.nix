{
  flake-file.inputs = {
    secrets = {
      url = "git+ssh://git@github.com/JacobGDG/nix-secrets.git?shallow=1";
      flake = false;
    };
    ragenix = {
      url = "github:JacobGDG/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.secrets = {inputs, ...}: {
    imports = [inputs.ragenix.nixosModules.default];

    age = {
      # impermanence mounts after agnix runs, so use persisted version directly
      identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
