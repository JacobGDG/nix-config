# https://github.com/ryantm/agenix
{
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
    "home_wg_config.conf" =
      {
        file = "${inputs.mysecrets}/home_wg_config.conf.age";
      }
      // high_security;
  };
}
