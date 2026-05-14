{jg, ...}: {
  jg.tui.includes = [jg.ripgrep];

  jg.ripgrep.homeManager = {
    programs.ripgrep = {
      enable = true;
      arguments = ["--smart-case"];
    };
  };
}
