{ pkgs, ... }:
{
  home.packages = with pkgs; [
    llm-agents.orca
  ];
}
