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

  myModules = {
    llm.enable = true;
  };

  home.packages = with pkgs; [
    btop
    ruby
  ];
}
