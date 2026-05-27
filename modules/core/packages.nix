{
  flake.modules.homeManager.core = {pkgs, lib, ...}: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      bc
      nerd-fonts.jetbrains-mono
      ruby
      unzip
    ] ++ lib.optionals stdenv.isLinux [
      sshfs
      wl-clipboard
    ];
  };
}
