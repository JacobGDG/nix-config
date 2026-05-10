{
  inputs,
  lib,
  ...
}: {
  imports = [
    (inputs.den.namespace "jg" false)
  ];

  den.schema.user.classes = lib.mkDefault ["homeManager"];
}
