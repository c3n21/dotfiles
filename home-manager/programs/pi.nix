{ pkgs, ... }:
{
  programs = {
    pi-coding-agent = {
      enable = true;
      extraPackages = [
        pkgs.nodejs
        pkgs.bun
      ];
      package = pkgs.llm-agents.pi;

      models = {
        providers.openai-codex.modelOverrides = {
          "gpt-6.1-sol".contextWindow = 1050000;
          "gpt-5.6-sol".contextWindow = 1050000;
        };
      };
      settings = {
        packages = [
          # "npm:@termdraw/pi"
          "npm:pi-auto-resume"
          "npm:pi-subagents"
          "npm:pi-web-access"
          # "npm:pi-mcp-adapter"
          # "npm:@gotgenes/pi-permission-system"
          "git:github.com/obra/superpowers"
          # "npm:pi-mcp-adapter"
        ];

        theme = "dark";

        "autoResume" = {
          "enabled" = true;
          "maxResumes" = 5;
          "delayMs" = 1000;
          "continuePrompt" = "Continue from where you left off. Do not repeat what you've already written.";
          "rateLimit" = {
            "enabled" = true;
            "maxRetries" = 3;
            "baseDelayMs" = 60000;
            "maxDelayMs" = 3600000;
          };
        };

        subagents.agentOverrides = {
          scout = {
            model = "openai-codex/gpt-5.6-luna";
            thinking = "low";
          };
          researcher = {
            model = "openai-codex/gpt-5.6-luna";
            thinking = "low";
          };
          delegate = {
            model = "openai-codex/gpt-5.6-luna";
            thinking = "low";
          };
          "context-builder" = {
            model = "openai-codex/gpt-5.6-luna";
            thinking = "medium";
          };
          planner = {
            model = "openai-codex/gpt-5.6-terra";
            thinking = "medium";
          };
          worker = {
            model = "openai-codex/gpt-5.6-terra";
            thinking = "high";
          };
          reviewer = {
            model = "openai-codex/gpt-5.6-terra";
            thinking = "medium";
          };
          oracle = {
            model = "openai-codex/gpt-5.6-sol";
            thinking = "high";
          };
        };
      };
    };
  };
}
