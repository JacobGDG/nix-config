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
      jg.ai

      jg.hyprland

      jg.gruvbox

      jg.kitty
      jg.firefox
      jg.mpv
      jg.cava
      jg.dconf
      jg.thunderbird
      jg.filemanager
      jg.libreoffice
      jg.discord
    ];
    homeManager = {pkgs, ...}: {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        # monitoring
        bottom
        dig
        btop
        tree
        watch

        # cli tools
        fzf
        gh
        jq
        just
        tealdeer # tldr
        yq-go

        # productivity
        ttyper
        tomato-c

        # gaming
        prismlauncher
        mumble

        # utilities
        rpi-imager

        # lint
        ripsecrets

        # fonts
        nerd-fonts.jetbrains-mono
      ];
    };
  };
}
