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
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        step-cli # certificate information
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
        ]
      )
      ++ lib.optionals cfg.aws.enable (
        with pkgs; [
          aws-sso-util
        ]
      );

    programs.zsh.shellAliases = lib.mkIf cfg.kubernetes.enable {
      "k" = "kubectl";
      "kns" = "kubens";
      "kctx" = "kubectx";
    };
  };
}
