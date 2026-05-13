{
  jg,
  den,
  ...
}: {
  jg.ai.includes = [jg.claude];

  jg.claude = {
    includes = [(den.provides.unfree ["claude-code"])];

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [opencode];
      programs.claude-code = {
        enable = true;
        settings.theme = "dark";
      };
    };
  };
}
