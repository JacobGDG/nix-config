{
  den,
  jg,
  ...
}: {
  den.aspects.jake = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      (den.provides.user-shell "zsh")
      jg.tui
    ];
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [htop tealdeer];
    };
  };
}
