# nix-configs

Configuration of all my machines: system config via [NixOS](https://nixos.org) and [nix-darwin](https://github.com/nix-darwin/nix-darwin), user space config via [home-manager](https://github.com/nix-community/home-manager). Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix).

| Node         | OS                    | Architecture | Configs                   |
| ------------ | --------------------- | ------------ | ------------------------- |
| `fk-desktop` | NixOS                 | x86_64       | NixOS + home-manager      |
| `fk-t14`     | NixOS                 | x86_64       | NixOS + home-manager      |
| `fk-mbp21`   | macOS (Apple Silicon) | aarch64      | nix-darwin + home-manager |

## Structure

```
flake.nix     inputs, the mkNode function, the list of nodes, checks, dev shell
nixos/        NixOS modules shared by all NixOS nodes (imported through nixos/default.nix)
nixos/workstation/  desktop/laptop-only NixOS modules, skipped for nodes tagged `server`
darwin/       nix-darwin modules shared by all macOS nodes (imported through darwin/default.nix)
home/         home-manager modules shared by all nodes (imported through home/default.nix)
nixpkgs.nix   overlays and nixpkgs config shared by home-manager, NixOS and nix-darwin
tags.nix      the node tag option and the `hasTag` helpers, imported by every module set
theme.nix     fonts and Catppuccin theming, part of the shared home-manager modules
secrets/      sops-encrypted secrets, see .sops.yaml for the keys
nodes/<node>/ configuration specific to a single node
```

### Nodes

`flake.nix` declares every machine as an entry in the `nodes` list:

```nix
{ user = "fkoehler"; system = "x86_64-linux"; node = "fk-t14"; }
```

`mkNode` turns such an entry into flake outputs, depending on `system`:

| Output                                       | Created for    | Modules                                                             |
| -------------------------------------------- | -------------- | ------------------------------------------------------------------- |
| `homeConfigurations."<user>@<node>"`         | every node     | `home/` + `theme.nix` + `nodes/<node>/home.nix`                     |
| `nixosConfigurations.<node>`                 | Linux systems  | `nixos/` + `nodes/<node>/nixos.nix`                                 |
| `darwinConfigurations.<node>`                | Darwin systems | `darwin/` + `nodes/<node>/darwin.nix`                               |
| `checks.<system>.{home,nixos,darwin}-<node>` | every node     | the configurations above, evaluated by `nix flake check --no-build` |

`user` and `inputs` are passed to the NixOS and nix-darwin modules via `specialArgs` (and to home-manager via `extraSpecialArgs`). `home.username` and `home.homeDirectory` are derived from `user` and `system`, so node files don't have to set them.

Everything that differs between machines lives in `nodes/<node>/`:

| File          | Used by      | Typical content                                                                                |
| ------------- | ------------ | ---------------------------------------------------------------------------------------------- |
| `nixos.nix`   | NixOS nodes  | host name, [nixos-hardware](https://github.com/NixOS/nixos-hardware) profiles, GPU workarounds |
| `disko.nix`   | NixOS nodes  | [disko](https://github.com/nix-community/disko) disk layout                                    |
| `facter.json` | NixOS nodes  | [nixos-facter](https://github.com/nix-community/nixos-facter) hardware report                  |
| `darwin.nix`  | Darwin nodes | Homebrew taps and other macOS-only system settings                                             |
| `home.nix`    | every node   | node tags (see `home/tags.nix`) and macOS user defaults                                        |

Node tags (`nodeTags` in `home.nix`, e.g. `speqtral`) enable optional home-manager modules such as the work accounts, SSH hosts and AWS credentials.

## Applying Configuration

The flake attribute is picked automatically from the host name (and user name for home-manager), so `.` is enough on each machine.

### NixOS

```bash
sudo nixos-rebuild switch --flake .
# or: install for the next boot only
sudo nixos-rebuild boot --flake .
```

### macOS

```bash
darwin-rebuild switch --flake .
```

### home-manager

```bash
home-manager switch -b backup --flake .
```

---

## Development

Enter the dev shell to get home-manager, darwin-rebuild (on macOS) and the pre-commit hooks:

```bash
nix develop
```

Run all formatters and linters:

```bash
nix fmt
```

Pre-commit hooks run `deadnix`, `nil`, `nixfmt`, and `statix` on Nix files and `ruff` on Python files.

Evaluate all configurations of the current system without building them:

```bash
nix flake check --no-build
```

On Linux this also reports an error for the macOS home-manager config, which can only be evaluated on a Mac.

---

## Adding a PWA Desktop Entry

PWA entries are declared in `home/edge.nix` under `xdg.desktopEntries`. Each entry needs an icon fetched from the app's PWA manifest.

**1. Find the manifest icon URL**

```bash
EDGE_UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0"
curl -sL -A "$EDGE_UA" https://example.com/manifest.json | python3 -m json.tool | grep -E '"src"|"sizes"|"purpose"'
```

Pick the largest `any`-purpose PNG (e.g. 256x256).

**2. Prefetch the icon and get its hash**

```bash
nix store prefetch-file --hash-type sha256 <icon-url>
```

**3. Add the entry**

```nix
xdg.desktopEntries.my-app = {
  name = "My App";
  exec = "${edge} --app=https://example.com";
  terminal = false;
  icon = "${pkgs.fetchurl {
    url = "<icon-url>";
    hash = "<sha256-...>";
  }}";
  categories = [ "..." ];
};
```

If the icon URL contains a version string (e.g. `v2025`), a hash mismatch after an upstream update is the signal to refresh it.

---

## Debugging Steam Games

When a game fails to launch, check these logs (`1041720` is an example app ID, find it in the game's store URL):

| What                                   | Where                                                                    |
| -------------------------------------- | ------------------------------------------------------------------------ |
| Steam client output (stdout/stderr)    | `journalctl --user -t steam --since "10 min ago"`                        |
| Exact launch command, start/exit times | `~/.local/share/Steam/logs/console_log.txt`                              |
| Proton / Steam Linux Runtime selection | `~/.local/share/Steam/logs/compat_log.txt`                               |
| Downloads, updates, app state changes  | `~/.local/share/Steam/logs/content_log.txt`                              |
| Proton/Wine log of the game            | `~/steam-<appid>.log`, enable via launch option `PROTON_LOG=1 %command%` |

If the game process is added and removed within the same second in `console_log.txt`, the launch wrapper (e.g. gamescope) died before Proton ran: check the journal for its error output.
