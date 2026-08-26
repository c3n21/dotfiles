# To download manually the models
# systemd-run --unit=llama-cpp-model-download   --collect   --property=Type=exec   --property=DynamicUser=yes   --property=CacheDirectory=llama-cpp   --property='Environment=LLAMA_CACHE=/var/cache/llama-cpp'     llama-server     -hf ggml-org/gemma-3-4b-it-GGUF:Q4_K_M     --host 127.0.0.1     --port 8081

{ pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [
    llama-cpp-vulkan
    vulkan-tools
  ];

  systemd.services.llama-cpp = {
    wantedBy = lib.mkForce [ ];
  };

  services.firewalld = {
    zones = {
      public = {
        ports = [
          {
            port = 8080;
            protocol = "tcp";
          }
        ];
      };
    };
  };

  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-vulkan;
    openFirewall = true;
    # package = (pkgs.llama-cpp.override { cudaSupport = true; })
    # package = pkgs.llama-cpp-rocm;

    settings =
      let
      in
      {
        # model = modelPath;
        alias = "local";

        host = "0.0.0.0";
        port = 8080;

        # Offload everything possible to the Radeon 780M.
        # "n-gpu-layers" = "all";

        # Auto is safer across different models and Vulkan kernels.
        # Benchmark "on" afterward if desired.
        "flash-attn" = "auto";

        # Optimized for one interactive user.
        parallel = 1;

        # 7840U: 8 physical cores / 16 threads.
        threads = 8;
        "threads-batch" = 16;

        # Good starting values for prompt processing on this APU.
        "batch-size" = 2048;
        "ubatch-size" = 512;

        # Larger contexts consume more RAM and reduce performance.
        "ctx-size" = 32768;

        # Necessary for reliable chat templates and tool calling.
        jinja = true;

        # Exposes performance counters at /metrics.
        metrics = true;
      };
  };

}
