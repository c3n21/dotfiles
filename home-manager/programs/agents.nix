# Global instructions shared by every coding agent on this machine.
#
# The file is symlinked out of the store rather than rendered into it, so edits
# to home-manager/agents/AGENTS.md take effect in the next agent session without
# a rebuild. Being tracked in git is what keeps an agent honest here: a
# self-modification shows up in `git diff` instead of being silently blocked.
# It lives under home-manager/ because .gitignore is an allowlist and only
# nixos/ and home-manager/ are un-ignored.
#
# Deliberately does not use `programs.claude-code.context` or
# `programs.opencode.context`. Both would copy the content into /nix/store,
# which costs a rebuild per wording change. If either option is ever set, it
# defines the same paths as below and evaluation will conflict.
{ config, ... }:
let
  agentsFile = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/home-manager/agents/AGENTS.md";
in
{
  home.file.".claude/CLAUDE.md".source = agentsFile;
  home.file.".gemini/config/AGENTS.md".source = agentsFile;
  xdg.configFile."opencode/AGENTS.md".source = agentsFile;
  xdg.configFile."AGENTS.md".source = agentsFile;
}
