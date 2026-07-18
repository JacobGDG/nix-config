{
  flake-file.inputs.bark = {
    url = "git+ssh://git@github.com/JacobGDG/bark.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  flake.modules.homeManager.bark = { pkgs, inputs, ... }: {
    home.packages = [ inputs.bark.packages."${pkgs.system}".default ];
  };
}
