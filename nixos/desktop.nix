# This file is used to setup a desktop environment
{
  pkgs,
  lib,
  ...
}:
let
  delugia-code = pkgs.callPackage ./delugia-code { };
in
rec {
  boot = {
    supportedFilesystems = {
      nfs = true;
    };
    kernelParams = [
      # Turn off tty screen after 5 minutes
      "consoleblank=300"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "fs.inotify.max_queued_events" = 100000;
    };
    loader = {
      efi.canTouchEfiVariables = true;
    };
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
      ];
    };
  };

  # laptop
  powerManagement.enable = true;
  services = {
    kanata = {
      enable = true;
      keyboards = {
        laptop = {
          config =
            # lisp
            ''
              (defsrc
                caps esc c h j k l
              )

              (defalias
                scroll-layer
                  (layer-while-held scrolling)

                scroll-left
                  (mwheel-accel-left 3 1200 1.15 0.93)

                scroll-down
                  (mwheel-accel-down 3 1200 1.15 0.93)

                scroll-up
                  (mwheel-accel-up 3 1200 1.15 0.93)

                scroll-right
                  (mwheel-accel-right 3 1200 1.15 0.93)
              )

              (deflayer base
                esc @scroll-layer c h j k l
              )

              (deflayer scrolling
                _ _ caps @scroll-left @scroll-down @scroll-up @scroll-right
              )
            '';

          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd" # framework-13-7040-amd
          ];
        };
      };
    };
    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
      # When the laptop is plugged to an external monitor
      HandleLidSwitchDocked = "suspend-then-hibernate";
    };
    thermald.enable = true;
    fwupd.enable = true;
    upower.enable = true;
  };

  security = {
    pam.services = {
      # Needed for swaylock integration in userland
      # https://home-manager.dev/manual/unstable/options.xhtml#opt-programs.swaylock.enable
      swaylock = { };
      login = {
        kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
          forceRun = true;
        };
      };
    };
    rtkit.enable = true;
    polkit.enable = true;
  };

  xdg.portal.extraPortals = [
    pkgs.kdePackages.kwallet
  ];

  # Enable networking
  networking = {
    # make wireguard work in conjunction with nm
    # https://wiki.nixos.org/wiki/WireGuard
    firewall.checkReversePath = "loose";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
      dns = "systemd-resolved";
      wifi = {
        powersave = true;
        macAddress = "stable-ssid"; # mac address generation is stable per ssid
        # backend = "iwd";
      };
    };
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = false; # powers up the default Bluetooth controller on boot  };
  };

  # Enable common container config files in /etc/containers
  virtualisation = {
    containers = {
      enable = true;
    };
    docker.enable = true;
    podman = {
      enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      kdePackages.kwalletmanager
      sbctl

      # Podman
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      podman-compose # start group of containers for dev
    ];
  };

  programs = {
    fish = {
      enable = true;
    };
    nix-ld = {
      enable = true;
      libraries = lib.mkForce [ ];
    };
    gamescope = {
      enable = true;
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
    };

    npm = {
      enable = true;
    };
    virt-manager.enable = true;
  };

  services = {
    resolved = {
      enable = networking.networkmanager.dns == "systemd-resolved";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig = {
        pipewire-pulse = {
          "92-low-latency.conf" = {
            context.modules = [
              {
                name = "libpipewire-module-protocol-pulse";
                args = {
                  pulse.min.req = "32/48000";
                  pulse.default.req = "32/48000";
                  pulse.max.req = "32/48000";
                  pulse.min.quantum = "32/48000";
                  pulse.max.quantum = "32/48000";
                };
              }
            ];
            stream.properties = {
              node.latency = "32/48000";
              resample.quality = 1;
            };
          };
        };
      };
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      source-han-sans
      source-han-serif
      delugia-code
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Sarasa Mono SC"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Source Han Sans SC"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Source Han Serif SC"
          "DejaVu Serif"
        ];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zhifan = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Zhifan Chen";
    initialPassword = "changeme";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "libvirtd"
      "podman"
      "docker"
      "adbusers"
    ];
  };
}
