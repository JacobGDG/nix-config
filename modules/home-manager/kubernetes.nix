{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    kubectl
    k9s
    kubectx
    kustomize
  ];

  programs.zsh.shellAliases = {
    "k" = "kubectl";
  };
}
