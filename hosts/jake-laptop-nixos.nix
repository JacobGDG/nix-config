{
  pkgs,
  mylib,
  ...
}: {
  imports =
    [
      ./common/linux-base.nix
    ]
    ++ (map mylib.homeManagerModules [
      "my-modules/"
    ]);

  home.packages = with pkgs; [
    btop
  ];
}
