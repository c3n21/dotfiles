# How to activate a configuration

```
nixos-rebuild switch --sudo --flake .#framework-13-7040-amd --show-trace -L --fallback --refresh --keep-going
```

--fallback to build an output when no substituter has the thing built
--keep-going because why not
--refresh to refresh substituters metadata

# Test remote builds

```bash
nix build -vv --max-jobs 0 --option substitute false --option builders-use-substitutes false --expr "derivation { name = \"remote-test-$(date +%s%N)\"; system = \"x86_64-linux\"; builder = \"/bin/sh\"; args = [ \"-c\" \"echo ok > \$out\" ]; }"
```

# FAQ

## When a derivation seems to be corrupted

```bash
nix store repair <store path>
```
