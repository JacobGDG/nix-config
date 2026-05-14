{jg, ...}: {
  jg.tui.includes = [jg.jujutsu];
  jg.jujutsu.homeManager = {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "JacobGDG";
          email = "10035081+JacobGDG@users.noreply.github.com";
        };
      };
    };
  };
}
