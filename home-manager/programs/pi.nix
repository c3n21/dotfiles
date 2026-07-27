{ pkgs, lib, ... }:
let
  version = "0.80.2";
  src = pkgs.fetchFromGitHub {
    owner = "earendil-works";
    repo = "pi";
    tag = "v${version}";
    hash = "sha256-aKtgPc3rwHEp856jP3N7nImph0CSG+gsWq9OVci3hmE=";
  };
  # basePackage = pkgs.pi-coding-agent.overrideAttrs (oldAttrs: rec {
  #   inherit version src;
  #   npmDeps = pkgs.fetchNpmDeps {
  #     inherit src;
  #     hash = "sha256-1EGs8lX8XoAnRtS+pw4lBRm24U/vtVB2loVRmZyd4Z8=";
  #   };
  # });

  basePackage = pkgs.pi-coding-agent;
  package = pkgs.symlinkJoin {
    name = "pi-coding-agent-${basePackage.version}-all-tools";
    paths = [ basePackage ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/pi \
        --add-flags "--tools read,bash,edit,write,grep,find,ls"
    '';
  };
in
{

  programs = {
    pi-coding-agent = {
      enable = true;
      extraPackages = [
        pkgs.nodejs
        pkgs.bun
      ];
      package = package;
      settings = {
        packages = [
          "npm:@termdraw/pi"
          "npm:pi-subagents"
          "npm:pi-web-access"
          "npm:pi-mcp-adapter"
          "npm:@gotgenes/pi-permission-system"
          # "npm:pi-mcp-adapter"
        ];

        theme = "dark";

      };
      context = # markdown
        ''
          # Environment

          The user is running NixOS.

          This system is declarative and reproducible.

          Prefer:
          - flakes
          - nix shell
          - nix develop
          - nix run
          - home-manager
          - NixOS modules
          - project-local tooling

          Avoid recommending:
          - curl | sh installers
          - global npm/pip installs
          - manual /usr/local modifications
          - distro-specific instructions for Ubuntu/Debian unless explicitly requested

          Assume:
          - systemd is available
          - modern Linux tooling is available
          - the user is comfortable with terminal workflows
          - the user is a technical user

          # General behavior

          - Prefer inspecting before changing.
          - Always ask for permission before making modifications to the system, configuration, services, repositories, disks, or user files.
          - Explain dangerous commands before suggesting or running them.
          - Preserve existing user changes.
          - Be concise but technically precise.
          - For debugging, prioritize root-cause analysis over quick hacks.
          - When troubleshooting, gather evidence incrementally instead of guessing.
          - Show relevant commands and explain what they verify.
          - Prefer reversible changes.
          - Do not use `cat`, `head`, `tail`, `sed`, `awk`, `grep`, `rg`, `find`, or `ls` through Bash when an equivalent structured tool is available.
          - Reserve Bash for compilation, tests, package management, version-control operations, and tasks that cannot be expressed through another tool.
        '';
    };
  };
}
