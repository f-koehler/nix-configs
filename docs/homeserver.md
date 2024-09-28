# Homeserver

## ZFS Filesystem

### `rpool` Datasets

Create a new dataset:

```bash
sudo zfs create -o canmount=on -o mountpoint=legacy rpool/<name>
```

Add mounting config:

```bash
fileSystems."/<mountpoint>" = {
  device = "rpool/jellyfin";
  fsType = "zfs";
};
```

### `tankX` datasets

#### Backup Dataset

```bash
sudo zfs create -o canmount=on <bool>/backups/<name>
```

## Services

### Nextcloud

The `occ` command to manage Nextcloud can be run via:

```bash
sudo -u nextcloud -g nextcloud nextcloud-occ <args>
```

### Paperless

The paperless management utilities (see [Paperless documentation](https://docs.paperless-ngx.com/administration/#management-commands)) can be run via:

```bash
sudo -u paperless -g paperless /var/lib/paperless/paperless-manage document_exporter <command> <args>
```

Example:

```bash
sudo -u paperless -g paperless /var/lib/paperless/paperless-manage document_sanity_checker -v 3
```
