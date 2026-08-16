{ pkgs, ... }:
{
  programs.antigravity-cli = {
    enable = true;
    package = pkgs.google-antigravity-cli;
  };
}
