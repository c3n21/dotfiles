# How to activate a configuration

```bash
sudo nixos-rebuild switch --flake .#framework-13-7040-amd --show-trace --specialisation niri -L && home-manager generations | head -1 | cut -d' ' -f7 | xargs -I{} echo "{}/specialisation/niri/activate" | xargs sh
```
