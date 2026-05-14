{inputs, ...}: {
  flake-file.inputs.ragenix = {
    url = "github:JacobGDG/ragenix/687ee92114bce9c4724376cf6b21235abe880bfa";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake-file.inputs.mysecrets = {
    url = "git+ssh://git@github.com/JacobGDG/nix-secrets.git?shallow=1";
    flake = false;
  };

  jg.secrets.nixos = {pkgs, ...}: {
    imports = [inputs.ragenix.nixosModules.default];

    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    environment.variables = {
      OPENAI_API_KEY_FILE = "/run/agenix/openai_api_key";
    };

    age.secrets.openai_api_key = {
      file = "${inputs.mysecrets}/openai_api_key.age";
      mode = "0500";
      owner = "jake";
    };
  };
}
