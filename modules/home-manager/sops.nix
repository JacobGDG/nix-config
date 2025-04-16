{pkgs, ...}: {
  home.packages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
