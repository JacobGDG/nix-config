{
  flake.modules.homeManager.devops = {pkgs, ...}: {
    home.packages = with pkgs; [
      aws-sso-util
      awscli2
      cmctl
      k9s
      kind
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      step-cli
      tenv
      tflint
    ];

    programs.zsh.shellAliases = {
      "k" = "kubectl";
      "kns" = "kubens";
      "kctx" = "kubectx";
    };
  };
}
