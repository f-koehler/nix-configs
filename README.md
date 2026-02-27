
# Non-NixOS GPU Setup

To allow passwordless `sudo` to update SELinux rules during `home-manager` activation:
```bash
echo 'fkoehler ALL=(root) NOPASSWD: /nix/store/*/bin/non-nixos-gpu-setup' | sudo tee /etc/sudoers.d/nix-non-nixos-gpu-setup
sudo chmod 440 /etc/sudoers.d/nix-non-nixos-gpu-setup
```

## SELinux and `home-manager`'s `non-nixos-gpu`

To set the security context for `non-nixos-gpu.service` correctly:
```bash
sudo semanage fcontext -a -t systemd_unit_file_t '/nix/store/[^/]+-non-nixos-gpu/lib/systemd/system/non-nixos-gpu\.service'
```

To allow passwordless `sudo` to update SELinux rules during `home-manager` activation:
```bash
echo 'fkoehler ALL=(root) NOPASSWD: /usr/sbin/restorecon /nix/store/*/lib/systemd/system/non-nixos-gpu.service' | sudo tee /etc/sudoers.d/nix-restorecon
sudo chmod 440 /etc/sudoers.d/nix-restorecon
```
