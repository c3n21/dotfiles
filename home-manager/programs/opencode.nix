{
  programs.opencode.settings = {
    model = "litellm/qwen-local";
    small_model = "litellm/qwen-local";

    provider.litellm = {
      name = "LiteLLM";

      # LiteLLM exposes /v1/chat/completions.
      npm = "@ai-sdk/openai-compatible";

      options = {
        baseURL = "http://100.64.0.10:4000/v1";

        # Local inference may need longer than OpenCode's defaults.
        timeout = 600000;
        chunkTimeout = 60000;
      };

      models.qwen-local = {
        name = "Qwen local with cloud fallback";

        limit = {
          context = 32768;
          output = 8192;
        };
      };
    };
    "agent" = {
      "explore" = {
        "model" = "openai/gpt-5.6-luna";
        "reasoningEffort" = "none";
      };
      "scout" = {
        "model" = "openai/gpt-5.6-luna";
        "reasoningEffort" = "none";
      };
    };
  };
}
