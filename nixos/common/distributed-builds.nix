{ pkgs, ... }:
{
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "nixos.private.headscale.com";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/remotebuild";
      system = pkgs.stdenv.hostPlatform.system;
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
        # "benchmark"
      ];
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      mandatoryFeatures = [ ];

    }
  ];
}
