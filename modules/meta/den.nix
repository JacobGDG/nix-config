{inputs, ...}: {
  imports = [
    inputs.den.flakeModules.dendritic
    inputs.flake-file.flakeModules.dendritic
    (inputs.den.namespace "jk" false)
  ];
}
