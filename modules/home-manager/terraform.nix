{pkgs, ...}: {
  home.packages = with pkgs; [
    opentofu
    tflint
    checkov
    terraform
  ];
}
