{pkgs, ...}: {
  home.packages = with pkgs; [
    tenv # tofu version manager
    tflint
    checkov
  ];
}
