# https://github.com/ryantm/agenix
{
  hostConfig,
  inputs,
  config,
  lib,
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
    owner = hostConfig.username;
  };
in {
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  environment.variables = {
    OPENAI_API_KEY_FILE = config.age.secrets.openai_api_key.path;
  };

  age.secrets = {
    openai_api_key =
      {
        file = "${inputs.mysecrets}/openai_api_key.age";
      }
      // user_readable;
  };
}
