# How to activate a configuration

```
nixos-rebuild switch --sudo --flake .#framework-13-7040-amd --show-trace -L --fallback --refresh --keep-going
```

--fallback to build an output when no substituter has the thing built
--keep-going because why not
--refresh to refresh substituters metadata
