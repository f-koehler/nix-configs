# Nix Configurations

## User Configuration

### Local Deployment

The user configurations can be deployed deployed via `home-manager`

```bash
home-manager switch --flake .
```

or using the `nh` utility (nicer output)

```bash
nh home switch .
```

To build without switching, replace `switch` with `build`.

### Implementation

The user configurations are specified in the `homeConfigurations` flake output and built using the `mkHome` function from [`lib/default.nix`](lib/default.nix). This function loads the [`home/default.nix`](home/default.nix) module containing all the configuration. Components are enabled and configured based on the `config-*` attribute set passed to `mkHome`.

## System Configurations

| :computer: Name                                         | :floppy_disk: OS  | :speech_balloon: Comment     |
| ------------------------------------------------------- | ----------------- | ---------------------------- |
| `fkt14`                                                 | :snowflake: NixOS | Work laptop at SpeQtral      |
| `homeserver` ([:closed_book: docs](docs/homeserver.md)) | :snowflake: NixOS | Home server for self-hosting |
| `mbp21` ([:closed_book: docs](docs/mbp21.md))           | :apple: Mac OS    | Personal laptop              |

### Local Deployment (NixOS)

The NixOS configurations can be deployed deployed via `nixos-rebuild`

```bash
sudo nixos-rebuild boot --flake .
```

or using the `nh` utility (nicer output)

```bash
nh os boot .
```

To switch to the new configuration immediately, replace `boot` with `switch`.
To just build without switching, replace `boot` with `build`.

### Local Deployment (Mac OS)

The NixOS configurations can be deployed deployed via `darwin-rebuild`

```bash
darwin-rebuild switch --flake .
```

To just build without switching, replace `boot` with `build`.
