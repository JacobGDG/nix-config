{
  flake-file.inputs.bark = {
    url = "git+ssh://git@github.com/JacobGDG/bark.git?shallow=1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  persist = {
    users = {
      directories = [
        "worktrees"
      ];
    };
  };

  flake.modules.homeManager.bark = {
    pkgs,
    inputs,
    ...
  }: {
    imports = [inputs.bark.homeManagerModules.default];

    programs.bark = {
      enable = true;
      settings = {
        tmux.startup_command = " tmuxifier load-window vimsplit && tmux move-window -t 1 && tmux kill-window -t 1";
      };
    };
  };
}
