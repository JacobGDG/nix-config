{mylib, ...}: {
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ./hyprland
    ];
}
