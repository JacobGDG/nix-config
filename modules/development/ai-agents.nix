{
  nixpkgs.allowedUnfreePackages = ["claude-code"];

  flake.modules.homeManager.aiAgents = {pkgs, ...}: {
    home.packages = with pkgs; [
      opencode
    ];

    programs.claude-code = {
      enable = true;
      settings = {
        theme = "dark";
        customInstructions = "When cloning public git repositories, clone them to /tmp/<repo>.";
      };
    };
  };
}
