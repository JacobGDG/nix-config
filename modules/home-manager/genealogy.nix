{pkgs, ...}: {
  home.packages = with pkgs; [
    gramps
    graphviz
  ];
}
