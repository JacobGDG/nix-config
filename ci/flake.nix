{
  outputs = _: import ../. {tackOverrides.secrets = ./stub-secrets;};
}
