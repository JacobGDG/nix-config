{
  pkgs,
  mylib,
  ...
}: {
  imports =
    [
      ./linux-base.nix
    ]
    ++ (map mylib.homeManagerModules [
      "my-modules/"
    ]);

  home.packages = with pkgs; [
    btop
  ];

  myModules.testModule = {
    enable = true;
    testValue = "Jake!";
  };
}
