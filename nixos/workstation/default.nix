{
  modulesPath,
  lib,
  pkgs,
  ...
}:
let
  gpuIDs = [
    "10de:0x1c03" # VGA
    "10de:0x10f1" # AUDIO
  ];
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix

    # boot
    ./uefi.nix

    # services
    # ../../services/proxmox-ve.nix
    # ../../services/jackett.nix
    # ../../services/prowlarr.nix
    # ../../services/sonarr.nix
    # ../../services/transmission.nix
  ];

  nix = {
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "zhifan"
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
  };

  # systemd.network.networks."10-lan" = {
  #   matchConfig.Name = [ defaultIf ];
  #   networkConfig = {
  #     Bridge = "vmbr0";
  #   };
  # };

  # systemd.network.netdevs."vmbr0" = {
  #   netdevConfig = {
  #     Name = "vmbr0";
  #     Kind = "bridge";
  #   };
  # };

  # systemd.network.networks."10-lan-bridge" = {
  #   matchConfig.Name = "vmbr0";
  #   networkConfig = {
  #     IPv6AcceptRA = true;
  #     DHCP = "ipv4";
  #   };
  #   linkConfig.RequiredForOnline = "routable";
  # };

  # networking.bridges.vmbr0.interfaces = [ defaultIf ];
  # networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;

  boot = {
    zfs = {
      requestEncryptionCredentials = true;

      forceImportRoot = false;
    };
    initrd = {
      kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        # "nvidia"
        # "nvidia_modeset"
        # "nvidia_uvm"
        # "nvidia_drm"
      ];
    };
    kernelParams = [
      "intel_iommu=on"
      ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
    ];
    extraModprobeConfig = ''
      softdep drm pre: vfio-pci
    '';
    supportedFilesystems = {
      "zfs" = true;
    }; # Enable ZFS support
  };

  hardware.graphics.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  disko.devices = {
    disk = {
      x = {
        type = "disk";
        device = "/dev/disk/by-id/ata-KINGSTON_SHFS37A120G_50026B7366015FA4";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        datasets = {
          "root" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
            mountpoint = "/";
          };
        };
        options = {
          # Workaround: cannot import 'zroot': I/O error in disko tests
          cachefile = "none";
        };
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = # bash
          "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostId = "d1ea89ad";
    hostName = "roshi";
  };

  services = {
    openssh.enable = true;
    zfs = {
      autoScrub.enable = true; # Periodically check for disk errors
      trim.enable = true; # Enable TRIM for SSDs
    };
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8/UX67h1Cls61eaDS85JW7h2bZRLopDbpsYRocxYdK Workstation"
  ];

  system.stateVersion = "25.05";
}
