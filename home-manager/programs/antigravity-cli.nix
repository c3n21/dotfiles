{ pkgs, ... }:
{
  programs.antigravity-cli = {
    enable = true;
    package = pkgs.llm-agents.antigravity-cli;
  };
}
