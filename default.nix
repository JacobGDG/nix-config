{
  tackOverrides ? {},
  flakeSelf ? null,
}: let
  pins = import ./.tack {overrides = tackOverrides;};
  inputs = pins // {self = self;};
  self =
    outputs
    // {
      inherit inputs;
      outPath =
        if flakeSelf != null
        then flakeSelf.outPath
        else ./.;
    };
  outputs = pins.flake-parts.lib.mkFlake {inherit inputs;} (pins.import-tree ./modules);
in
  outputs
