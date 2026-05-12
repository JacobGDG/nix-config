{
  jg.linux.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      xclip
    ];
  };
}
