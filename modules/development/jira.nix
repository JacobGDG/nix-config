{
  flake.modules.homeManager.jira = {pkgs, ...}: {
    home.packages = with pkgs; [
      jira-cli-go
    ];
  };
}
