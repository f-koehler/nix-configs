# Initial `nix-darwin` install

```bash
sh <(curl -L https://nixos.org/nix/install)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
nix run nix-darwin -- switch --flake ".#mbp21"
```
