{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    llama-cpp-vulkan
    vulkan-tools
  ];

  services.llama-cpp = {
    enable = false;
    package = pkgs.llama-cpp-vulkan;
    # package = (pkgs.llama-cpp.override { cudaSupport = true; })
    # package = pkgs.llama-cpp-rocm;

    settings =
      let
        modelDirectory = "/var/lib/llm-models";
        # Replace this symlink whenever you want to switch models.
        modelPath = "${modelDirectory}/current.gguf";
      in
      {
        # model = modelPath;
        alias = "local";

        host = "127.0.0.1";
        port = 8080;

        # Offload everything possible to the Radeon 780M.
        "n-gpu-layers" = "all";

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
        "ctx-size" = 8192;

        # Necessary for reliable chat templates and tool calling.
        jinja = true;

        # Exposes performance counters at /metrics.
        metrics = true;
      };
  };

}
