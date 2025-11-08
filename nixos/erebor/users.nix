{
  hostConfig,
  pkgs,
  ...
}: {
  users.users = {
    "${hostConfig.username}" = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];

      shell = pkgs.zsh;
      useDefaultShell = true;
    };
  };
}
