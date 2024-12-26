# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Common configuration for all machines
{
  inputs,
  pkgs,
  sugar-catppuccin,
  lib,
  hostName,
  ...
}: let
  delugia-code = pkgs.callPackage /home/zhifan/.config/nixos/delugia-code {};
in {
  services.flatpak.enable = true;

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-chinese-addons
      ];
    };
  };

  nix = {
    settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      auto-optimise-store = true;
      trusted-users = ["root" "zhifan"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # laptop
  powerManagement.enable = true;
  services = {
    thermald.enable = true;
    fwupd.enable = true;
    upower.enable = true;
  };

  # configure this only for intel
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "schedutils";

  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "schedutil";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;
  #     USB_DENYLIST = "0bda:8156";
  #     START_CHARGE_THRESH_BAT0 = 75;
  #     STOP_CHARGE_THRESH_BAT0 = 80;
  #   };
  # };

  security.pam.services = {
    swaylock = {};
    sddm = {
      name = "kwallet";
      enableKwallet = true;
    };
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "fs.inotify.max_queued_events" = 100000;
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };

    # Bootloader.

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    # boot.loader.systemd-boot.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  networking = {
    hostName = hostName; # Define your hostname.
    # firewall= {
    #   allowedUDPPorts = [3000 3001];
    #   allowedTCPPorts = [3000 3001];
    # };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

  # Configure keymap in X11
  services.xserver = {
    # for SDDM
    enable = true;
    xkb = {
      variant = "altgr-intl";
      layout = "us";
    };
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
        ovmf = {
          enable = true;
          packages = with pkgs; [
            OVMFFull.fd
          ];
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zhifan = {
    isNormalUser = true;
    description = "Zhifan Chen";
    extraGroups = ["networkmanager" "wheel" "video" "libvirtd" "podman" "docker"];
  };

  # home-manager.users.zhifan = {
  #   /* The home.stateVersion option does not have a default and must be set */
  #   home.stateVersion = "23.05";
  #   /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  # };

  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  # '';

  # xsession.pointerCursor = {
  #   package = pkgs.gnome3.defaultIconTheme;
  #   name = "Adwaita";
  #   size = 130;
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages =
      (with pkgs; [
        swaylock
        swayidle
        git
        libsForQt5.kwallet
        libsForQt5.kwallet-pam
        libsForQt5.kwalletmanager
        libsForQt5.qt5.qtgraphicaleffects
        javaPackages.openjfx17
        sbctl

        # Podman
        dive # look into docker image layers
        podman-tui # status of containers in the terminal
        podman-compose # start group of containers for dev
      ])
      ++ [sugar-catppuccin];
  };

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        acl
        attr
        bzip2
        curl
        gtk3
        javaPackages.openjfx17
        jdk17
        libGL
        libsodium
        libssh
        libxml2
        nodejs
        openssl
        sqlite
        stdenv.cc.cc
        systemd
        util-linux
        xorg.libXtst
        xz
        zlib
        zstd
      ];
    };
    npm = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    nano = {
      enable = false;
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    virt-manager.enable = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  services = {
    blueman.enable = true;
  };

  services.displayManager = {
    sddm = {
      theme = "sugar-catppuccin";
      enable = true;
    };
  };

  services.pipewire = {
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
        emoji = ["Noto Color Emoji"];
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
}
