{
  flake.modules.homeManager.devops = {pkgs, ...}: {
    home.packages = with pkgs; [
      kubectl
      k9s
      kubectx
      kustomize
      cmctl
      kubernetes-helm
      kind
      tenv
      tflint
      aws-sso-util
      step-cli
    ];

    programs.zsh.shellAliases = {
      "k" = "kubectl";
      "kns" = "kubens";
      "kctx" = "kubectx";
    };
  };
}
