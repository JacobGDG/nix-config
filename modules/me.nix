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

      jg.hyprland

      jg.gruvbox

      jg.kitty
    ];
    homeManager = {pkgs, ...}: {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        # monitoring
        bottom
        dig
        htop
        tree
        watch

        # cli tools
        fzf
        gh
        jq
        just
        tealdeer # tldr
        yq-go

        # security
        ripsecrets

        # fonts
        nerd-fonts.jetbrains-mono
      ];
    };
  };
}
