# Repository Instructions — `.config` Flake Repo

Personal machines of one user, all built from the same flake. NixOS +
home-manager.

## Environment & Project Structure

The NixOS + home-manager flake repo is checked out **at `~/.config` itself**, not
in a separate dotfiles directory. So `~/.config` holds two different kinds of
thing, and the difference matters before you edit anything there:

- `~/.config/{flake.nix,home-manager/,nixos/}` — the repo. Edit these.
- `~/.config/<app>/…` — mostly ordinary, unmanaged application config.
- A few paths are home-manager-managed and are read-only symlinks into
  `/nix/store` (e.g. `fish/config.fish`, `starship.toml`, `mimeapps.list`).
  Editing one fails or is reverted on the next rebuild. Change its source under
  `~/.config/home-manager/` instead.

Check with `readlink -f` before editing anything under `~/.config`. A stale second
checkout may exist elsewhere (e.g. `~/dotfiles`); confirm which tree is live via
`git log` before changing config.

## Flake & Rebuild

Rebuild — ask first, never run these unprompted:

```
nixos-rebuild switch --sudo --flake .#<config> --show-trace -L --fallback --refresh --keep-going
```

`<config>` is an attribute of `nixosConfigurations` in `flake.nix`, not the
hostname — the host `zenuko` builds `framework-13-7040-amd`, so neither
`--flake .` nor `.#$(hostname)` is safe. Read `flake.nix` to pick it; never
reuse one from a previous session. A non-NixOS host builds a
`homeConfigurations` attribute with `home-manager switch --flake .#<config>`
instead.

- Untracked files are invisible to flakes. `git add` new files or the build will
  not see them. `.gitignore` here is an allowlist (`*` plus `!` exceptions), so
  new files outside `nixos/` and `home-manager/` are ignored by default.
