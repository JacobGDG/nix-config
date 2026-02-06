{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ./base.nix
  ];

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home = {
    sessionPath = ["/opt/homebrew/bin/brew"];

    packages = with pkgs; [
      jira-cli-go
    ];
  };
}
