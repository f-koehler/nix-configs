

# Install

1. Boot from NixOS ISO
2. Set password for `root` user (run on host)
    ```shell
    passwd root
    ```
3. Define environment variables to specify flake reference and how to reach host:
   ```shell
   export CONFIG=homeserver-dev
   export HOST=192.168.122.164
   ```
3. Copy SSH key to live environment
   ```shell
   ssh-copy-id "root@${HOST}"
   ```
4. Install via `nixos-anywhere`:
   ```shell
   nixos-anywhere --generate-hardware-config nixos-facter ./os/hardware/${CONFIG}.json --flake ".#${CONFIG}" --target-host "root@${HOST}"
   ```

