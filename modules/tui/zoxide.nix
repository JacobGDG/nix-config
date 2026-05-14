{jg, ...}: {
  jg.tui.includes = [jg.zoxide];

  jg.zoxide.homeManager = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
