# This file is used to setup a desktop environment
{
  pkgs,
  lib,
  ...
}:
let
  delugia-code = pkgs.callPackage /home/zhifan/.config/nixos/delugia-code { };
in
{
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

  # laptop
  powerManagement.enable = true;
  services = {
    logind.lidSwitch = "suspend-then-hibernate";
    thermald.enable = true;
    fwupd.enable = true;
    upower.enable = true;
  };

  security.pam.services = {
    swaylock = { };
    sddm = {
      name = "kwallet";
      enableKwallet = true;
    };
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;

  qt = {
    enable = true;
    # TODO:
    # should check if this will make the theme between
    # GTK and QT not uniform
    platformTheme = "qt5ct";
  };

  # Enable networking
  networking.networkmanager.enable = true;

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

  environment = {
    systemPackages = with pkgs; [
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
    ];
  };

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        acl
        attr
        bzip2
        gtk3
        javaPackages.openjfx17
        jdk17
        libGL
        libsodium
        libssh
        libxml2
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
    virt-manager.enable = true;
  };

  services = {
    blueman.enable = true;
  };

  services.displayManager = {
    sddm = {
      wayland.enable = true;
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
    isNormalUser = true;
    description = "Zhifan Chen";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "libvirtd"
      "podman"
      "docker"
    ];
  };
}
