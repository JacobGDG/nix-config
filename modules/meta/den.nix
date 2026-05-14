{
  inputs,
  lib,
  ...
}: {
  imports = [
    (inputs.den.namespace "jg" false)
  ];
}
