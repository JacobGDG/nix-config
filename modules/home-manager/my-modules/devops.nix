{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.myModules.devops;
in {
  options = {
    myModules.devops = {
      enable = lib.mkEnableOption "devops";
      terraform.enable = lib.mkEnableOption "terraform";
      kubernetes.enable = lib.mkEnableOption "kubernetes";
      aws.enable = lib.mkEnableOption "aws";
      certificates.enable = lib.mkEnableOption "certificates";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
      ]
      ++ lib.optionals cfg.terraform.enable (
        with pkgs; [
          tenv # tofu version manager
          tflint
          checkov
        ]
      )
      ++ lib.optionals cfg.kubernetes.enable (
        with pkgs; [
          kubectl
          k9s
          kubectx
          kustomize
          cmctl # cert-manager
          kubernetes-helm
        ]
      )
      ++ lib.optionals cfg.aws.enable (
        with pkgs; [
          aws-sso-util
        ]
      )
      ++ lib.optionals cfg.certificates.enable (
        with pkgs; [
          step-cli
        ]
      );

    programs.zsh.shellAliases = lib.mkIf cfg.kubernetes.enable {
      "k" = "kubectl";
      "kns" = "kubens";
      "kctx" = "kubectx";
    };
  };
}
