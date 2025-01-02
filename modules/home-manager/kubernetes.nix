{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    kubectl
    k9s
    kubectx
  ];

  programs.zsh.shellAliases = {
    "k" = "kubectl";
  };
}
