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
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable the many devops tools used professionally
        '';
      };
      terraform = lib.mkOption {
        default = true;
        description = ''
          whether to enable Terraform tools
        '';
      };
      kubernetes = lib.mkOption {
        default = true;
        description = ''
          whether to enable Kubernetes tools
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      step-cli # certificate information
    ] ++ lib.optionals cfg.terraform (
      with pkgs; [
        tenv # tofu version manager
        tflint
        checkov
      ]
    ) ++ lib.optionals cfg.kubernetes (
      with pkgs; [
        kubectl
        k9s
        kubectx
        kustomize
      ]
    );

    programs.zsh.shellAliases = lib.mkIf cfg.kubernetes {
      "k" = "kubectl";
      "kns" = "kubens";
      "kctx" = "kubectx";
    };
  };

}
