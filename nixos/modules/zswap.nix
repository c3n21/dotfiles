{
  ...
}:

{
  boot.zswap = {
    enable = true;

    compressor = "zstd";
    zpool = "zsmalloc";

    maxPoolPercent = 25;

    shrinkerEnabled = true;

    acceptThresholdPercent = 90;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 120;
    "vm.vfs_cache_pressure" = 50;
  };

}
