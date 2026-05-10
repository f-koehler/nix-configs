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
