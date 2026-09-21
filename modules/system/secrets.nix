{
  flake-file.inputs = {
    secrets = {
      url = "git+ssh://git@github.com/JacobGDG/nix-secrets.git?shallow=1";
      flake = false;
    };
    ragenix = {
      url = "git+ssh://git@github.com/JacobGDG/ragenix.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.secrets = {inputs, ...}: {
    imports = [inputs.ragenix.nixosModules.default];

    age = {
      # TODO: confirm I can jsut refence the persisted value
      identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
