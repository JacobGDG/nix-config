{
  flake.modules.homeManager.core = {pkgs, ...}: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      bc
      nerd-fonts.jetbrains-mono
      ruby
      sshfs
      unzip
      wl-clipboard
    ];
  };
}
