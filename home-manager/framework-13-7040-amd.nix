{ pkgs, inputs, ... }: {
  imports = [
    ./home.nix
    ./programs/opencode.nix
    ./programs/claude-code.nix
    ./linux/packages-profiles/gaming.nix
    ./linux
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    telegram-desktop
    framework-tool
    adbfs-rootless
    localsend
    radeontop
    distrobox
  ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      };
    };
  };

  # TODO: enable this after refactoring home.nix
  # home = {
  #   stateVersion = "24.05"; # Please read the comment before changing.
  #   username = "zhifan";
  #   homeDirectory = pkgs.lib.mkForce "/home/zhifan";
  #   shell = {
  #     enableFishIntegration = true;
  #   };
  # };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  programs.opencode.settings = {
    "provider" = {
      "llama.cpp" = {
        "npm" = "@ai-sdk/openai-compatible";
        "name" = "llama-server (local)";
        "options" = {
          "baseURL" = "http://192.168.1.192:8080/v1";
        };
        "models" = {
          "bartowski/Qwen_Qwen3-30B-A3B-Instruct-2507-GGUF:Q4_K_M" = {
            "name" = "bartowski/Qwen_Qwen3-30B-A3B-Instruct-2507-GGUF:Q4_K_M";
            "limit" = {
              "context" = 16384;
              "output" = 8192;
            };
          };
        };
      };
    };
  };
}
