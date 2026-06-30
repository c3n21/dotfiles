{ ... }:
{
  nix.distributedBuilds = true;
  nix.settings = {
    builders-use-substitutes = true;
    # Prefer remote builders
    max-jobs = 1;
  };

  nix.buildMachines = [
    {
      # Remote host must be added to /root/.ssh/known_hosts
      # otherwise it will throw a generic error about not being able to start SSH connection
      hostName = "coordinator.private.headscale.com";
      sshUser = "remotebuilder";
      sshKey = "/root/.ssh/remotebuilder";

      # Supported build architectures
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
      ];
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
        # "benchmark"
      ];
      protocol = "ssh-ng";
      maxJobs = 2;
      speedFactor = 8;
      mandatoryFeatures = [ ];

    }
    {
      # Remote host must be added to /root/.ssh/known_hosts
      # otherwise it will throw a generic error about not being able to start SSH connection
      hostName = "thinkcentre.private.headscale.com";
      sshUser = "remotebuilder";
      sshKey = "/root/.ssh/remotebuilder";

      # Supported build architectures
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
      ];
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
        # "benchmark"
      ];
      protocol = "ssh-ng";
      maxJobs = 3;
      speedFactor = 8;
      mandatoryFeatures = [ ];

    }
  ];
}
