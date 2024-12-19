# https://github.com/ryantm/agenix
{
  config,
  platformConfig,
  inputs,
  ...
}: let
  noaccess = {
    mode = "0000";
    owner = "root";
  };
  high_security = {
    mode = "0500";
    owner = "root";
  };
  user_readable = {
    mode = "0500";
    owner = platformConfig.username;
  };
in {
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets = {
    testsecret =
      {
        file = "${inputs.mysecrets}/testsecret.age";
      }
      // high_security;
  };
}
