{ ... }:
let
  # Replace these with the exact values from /dev/disk/by-id.
  systemDisk = "/dev/disk/by-id/ata-LITEON_CV8-8E128-11_SATA_128GB_TW059X3VLOH008670FT3";
  dataDisk = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y1DPJL8Y";

  ssdMountOptions = [
    "compress=zstd"
    "noatime"
  ];

  hddMountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  disko.devices.disk = {
    ssd = {
      type = "disk";
      device = systemDisk;

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "1G";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            priority = 2;
            size = "20G";

            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          system = {
            priority = 3;
            size = "100%";

            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = ssdMountOptions;
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ssdMountOptions;
                };

                "@var" = {
                  mountpoint = "/var";
                  mountOptions = ssdMountOptions;
                };
              };
            };
          };
        };

      };
    };

    hdd = {
      type = "disk";
      device = dataDisk;

      content = {
        type = "gpt";

        partitions = {
          data = {
            start = "1M";
            size = "100%";

            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L"
                "data"
              ];

              subvolumes = {
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = hddMountOptions;
                };

                "@data" = {
                  mountpoint = "/data";
                  mountOptions = hddMountOptions;
                };
              };
            };
          };
        };
      };
    };
  };

}
