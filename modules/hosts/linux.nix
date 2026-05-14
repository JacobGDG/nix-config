{
  jg.linux.homeManager = {pkgs, ...}: {
    systemd.user.startServices = "sd-switch";

    home.packages = with pkgs; [
      xclip
      wl-clipboard
      bc
      unzip
      sshfs
    ];
  };
}
