{
  persist = {
    users = {
      directories = [
        ".ollama"
      ];
    };
  };

  flake.modules.homeManager.localLlm = {config, ...}: let
    ollamaUrl = "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
  in {
    # Runs `ollama serve` as a launchd agent (darwin) / systemd user service
    # (linux). Idle cost is ~40MB; models are loaded on first request and
    # unloaded after OLLAMA_KEEP_ALIVE. Models are not pulled declaratively,
    # run `ollama pull devstral-small-2:24b` once after switching.
    services.ollama = {
      enable = true;
      environmentVariables = {
        # Ollama's default context is too small for coding agents' system
        # prompts and tool definitions. 16k with a q8_0 KV cache keeps
        # devstral-small-2:24b (~15GB weights) near the GPU's share of a
        # 24GB Mac.
        OLLAMA_CONTEXT_LENGTH = "16384";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
        OLLAMA_KEEP_ALIVE = "30m";
      };
    };

    programs.opencode = {
      enable = true;
      settings = {
        model = "ollama/devstral-small-2:24b";
        provider.ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options.baseURL = "${ollamaUrl}/v1";
          models."devstral-small-2:24b".name = "Devstral Small 2 24B";
        };
      };
    };
  };
}
