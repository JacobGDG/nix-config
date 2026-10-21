{
  flake.modules.homeManager.devops = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      aws-sso-util
      awscli2
      cmctl
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

    programs.k9s = {
      enable = true;
      skins.prod.k9s = let
        c = config.colorScheme.palette;
      in {
        body.logoColor = "#${c.base08}";
        frame = {
          border = {
            fgColor = "#${c.base08}";
            focusColor = "#${c.base08}";
          };
          title = {
            fgColor = "#${c.base08}";
            highlightColor = "#${c.base0A}";
            counterColor = "#${c.base0A}";
          };
          crumbs = {
            fgColor = "#${c.base00}";
            bgColor = "#${c.base03}";
            activeColor = "#${c.base08}";
          };
        };
      };
    };
  };
}
