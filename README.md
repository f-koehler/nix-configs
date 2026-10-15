# nix-configs

User space configuration via [home-manager](https://github.com/nix-community/home-manager) for all my machines as well as system config of my Mac through [nix-darwin](https://github.com/nix-darwin/nix-darwin).

| Host      | OS                    | Architecture |
|-----------|-----------------------|--------------|
| `desktop` | Fedora Linux          | x86_64       |
| `fkt14`   | Fedora Linux          | x86_64       |
| `mbp`     | macOS (Apple Silicon) | aarch64      |

## Structure

```
flake.nix          entry point: inputs, home-manager/nix-darwin outputs, dev shell
darwin.nix         macOS system settings (nix-darwin)
theme.nix          fonts (CaskaydiaCove, Noto) and Catppuccin Mocha/Mauve theming used throughout all modules
home/
  default.nix      core programs: shell, terminal, CLI tools, session environment
  accounts.nix     email, calendar, and contact accounts
  firefox.nix      Firefox profile, forced extensions
  git.nix          Git with GPG commit signing
  kde.nix          KDE Plasma / Krohnkite settings (Linux only)
  linux.nix        GPU activation hook for non-NixOS (Linux only)
  ssh.nix          SSH host entries
  sftpman.nix      SFTP mount points (Linux only)
  zed-editor.nix   Zed editor extensions and settings
  zsh.nix          Zsh history, completion, vi-mode
nodes/
  desktop.nix      NVIDIA driver version + nixpkgs overlay workaround
  fkt14.nix        generic GPU support
  mbp.nix          macOS user directory and system defaults
```

## Applying Configuration

### User space for all machines

Apply user space config via `home-manager`:

```bash
home-manager switch -b backup --flake .
```

### macOS System Settings

Apply system settings via `nix-darwin`:

```bash
darwin-rebuild switch --flake .
```

---

## Development

Enter the dev shell to get home-manager, darwin-rebuild, and pre-commit hooks:

```bash
nix develop
```

Run all formatters and linters:

```bash
nix fmt
```

Pre-commit hooks run `deadnix`, `nil`, `nixfmt`, and `statix` on Nix files and `ruff` on Python files.

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

## Non-NixOS GPU Setup

The `targets.genericLinux.gpu` module runs `non-nixos-gpu-setup` during `home-manager` activation to link NVIDIA drivers from the Nix store. This requires passwordless `sudo` for the setup script:

```bash
echo 'fkoehler ALL=(root) NOPASSWD: /nix/store/*/bin/non-nixos-gpu-setup' | sudo tee /etc/sudoers.d/nix-non-nixos-gpu-setup
sudo chmod 440 /etc/sudoers.d/nix-non-nixos-gpu-setup
```

### SELinux

On SELinux-enabled systems (Fedora), set the correct security context for the systemd unit:

```bash
sudo semanage fcontext -a -t systemd_unit_file_t '/nix/store/[^/]+-non-nixos-gpu/lib/systemd/system/non-nixos-gpu\.service'
```

Allow passwordless `sudo` for `restorecon` during activation:

```bash
echo 'fkoehler ALL=(root) NOPASSWD: /usr/sbin/restorecon /nix/store/*/lib/systemd/system/non-nixos-gpu.service' | sudo tee /etc/sudoers.d/nix-restorecon
sudo chmod 440 /etc/sudoers.d/nix-restorecon
```

---

## Debugging Steam Games

When a game fails to launch, check these logs (`1041720` is an example app ID, find it in the game's store URL):

| What                                     | Where                                                                                       |
|------------------------------------------|---------------------------------------------------------------------------------------------|
| Steam client output (stdout/stderr)      | `journalctl --user -t steam --since "10 min ago"`                                           |
| Exact launch command, start/exit times   | `~/.local/share/Steam/logs/console_log.txt`                                                 |
| Proton / Steam Linux Runtime selection   | `~/.local/share/Steam/logs/compat_log.txt`                                                  |
| Downloads, updates, app state changes    | `~/.local/share/Steam/logs/content_log.txt`                                                 |
| Proton/Wine log of the game              | `~/steam-<appid>.log`, enable via launch option `PROTON_LOG=1 %command%`                    |

If the game process is added and removed within the same second in `console_log.txt`, the launch wrapper (e.g. gamescope) died before Proton ran: check the journal for its error output.

## Non-NixOS Noctalia Lock Screen

Noctalia (installed via Nix) authenticates through PAM using the service name `noctalia`. On Fedora there is no such service, so PAM falls back to `/etc/pam.d/other` (`pam_deny`) and every password is rejected. Additionally, Nix's `pam_unix.so` expects the setuid helper at `/run/wrappers/bin/unix_chkpwd`, which only exists on NixOS.

Create the PAM service:

```bash
printf '#%%PAM-1.0\nauth include login\n' | sudo tee /etc/pam.d/noctalia
```

Link the setuid helper and make it persist across reboots:

```bash
sudo mkdir -p /run/wrappers/bin
sudo ln -sf /usr/sbin/unix_chkpwd /run/wrappers/bin/unix_chkpwd
echo 'L+ /run/wrappers/bin/unix_chkpwd - - - - /usr/sbin/unix_chkpwd' | sudo tee /etc/tmpfiles.d/nix-unix-chkpwd.conf
```

If `include login` fails because of `pam_fprintd` (not available in Nix's `libpam`), use a minimal stack instead:

```
#%PAM-1.0
auth     required  pam_unix.so
account  required  pam_unix.so
```
