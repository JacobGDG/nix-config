{mylib, ...}: {
  imports =
    [
      ../common
    ]
    ++ mylib.scanPaths ./.;
}
