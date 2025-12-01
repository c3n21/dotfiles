{
  boot = {
    zfs = {
      requestEncryptionCredentials = true;

      forceImportRoot = false;
    };
    supportedFilesystems = [
      "zfs"
    ]; # Enable ZFS support
  };

  disko.devices = {
    disk = {
      x = {
        type = "disk";
        device = "/dev/disk/by-id/usb-Samsung_PSSD_T7_S6XDNS0W648443R-0:0";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "64G";
              content = {
                type = "swap";
                resumeDevice = true; # resume from hiberation from this device
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

}
