{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_GB-large
  ];
}
