# Homeserver

## Hardware

| Component           | Model                            |
| ------------------- | -------------------------------- |
| System              | Geekom NucBox G3                 |
| CPU                 | Intel N100 (4 cores, no HT)      |
| RAM                 | 32 GB                            |
| Disk `/`            | Kioxia 2TB PCIe 4.0 x4 SSD (ZFS) |
| Disk `/media/tank0` | Seagate Exos 18 TB via USB (ZFS) |
| Disk `/media/tank1` | Seagate Exos 18 TB via USB (ZFS) |

## Hosted Services

| :name_badge: Name | :snowflake: Module                                                 | :link: Links                                                                                                                                                                       | :speech_balloon: Purpose                                              |
| ----------------- | ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| audiobookshelf    | [`audiobookshelf.nix`](../nixos/homeserver/audiobookshelf.nix)     | [:earth_asia: website](https://www.audiobookshelf.org/), [:closed_book: docs](https://www.audiobookshelf.org/docs), [:gear: repo](https://github.com/advplyr/audiobookshelf)       | Streaming audiobooks                                                  |
| Forgejo           | [`forgejo.nix`](../nixos/homeserver/forgejo.nix)                   | [:earth_asia: website](https://forgejo.org/), [:closed_book: docs](https://forgejo.org/docs/latest/), [:gear: repo](https://codeberg.org/forgejo/forgejo)                          | Git forge, mostly for backups via gickup (see below)                  |
| Gickup            | [`gickup.nix`](../nixos/homeserver/gickup.nix)                     | [:closed_book: docs](https://cooperspencer.github.io/gickup-documentation/), [:gear: repo](https://github.com/cooperspencer/gickup)                                                | Backing up git repositories                                           |
| Homepage          | [`homepage.nix`](../nixos/homeserver/homepage.nix)                 | [:earth_asia: website](https://gethomepage.dev/), [:closed_book: docs](https://gethomepage.dev/widgets/), [:gear: repo](https://github.com/gethomepage/homepage)                   | Dashboard for quick access and overview over hosted services          |
| Invidious         | [`invidious.nix`](../nixos/homeserver/invidious.nix)               | [:earth_asia: website](https://invidious.io/), [:closed_book: docs](https://docs.invidious.io/), [:gear: repo](https://github.com/iv-org/invidious)                                | Watching YouTube with less nonsense                                   |
| Jellyfin          | [`jellyfin.nix`](../nixos/homeserver/jellyfin.nix)                 | [:earth_asia: website](https://jellyfin.org/), [:closed_book: docs](https://jellyfin.org/docs/), [:gear: repo](https://github.com/jellyfin/jellyfin)                               | Movie/TV show streaming                                               |
| Navidrome         | [`navidrome.nix`](../nixos/homeserver/navidrome.nix)               | [:earth_asia: website](https://www.navidrome.org/), [:closed_book: docs](https://www.navidrome.org/docs/), [:gear: repo](https://github.com/navidrome/navidrome)                   | Music streaming                                                       |
| Nextcloud         | [`nextcloud.nix`](../nixos/homeserver/nextcloud.nix)               | [:earth_asia: website](https://nextcloud.com/), [:closed_book: docs](https://docs.nextcloud.com/server/latest/admin_manual/), [:gear: repo](https://github.com/nextcloud/server)   | Groupware server hosting files, contacts, calendars, tasks, etc.      |
| Nginx             | [`nginx.nix`](../nixos/homeserver/nginx.nix)                       | [:earth_asia: website](https://nginx.org/en/), [:closed_book: docs](https://nginx.org/en/docs/), [:gear: repo](https://github.com/nginx/nginx)                                     | Reverse proxy for self-hosted services, does SSL termination          |
| Paperless         | [`paperless.nix`](../nixos/homeserver/paperless.nix)               | [:closed_book: docs](https://docs.paperless-ngx.com/), [:gear: repo](https://github.com/paperless-ngx/paperless-ngx)                                                               | Document management, archival, and OCR                                |
| PostgreSQL        | [`postgresql.nix`](../nixos/homeserver/postgresql.nix)             | [:earth_asia: website](https://www.postgresql.org/), [:closed_book: docs](https://www.postgresql.org/docs/current/index.html), [:gear: repo](https://github.com/postgres/postgres) | Database backend for various services (see [PostgreSQL](#postgresql)) |
| Samba             | [`samba.nix`](../nixos/homeserver/samba.nix)                       | [:earth_asia: website](https://www.samba.org/), [:closed_book: docs](https://www.samba.org/samba/docs/), [:gear: repo](https://gitlab.com/samba-team/samba)                        | File server                                                           |
| SearXNG           | [`searx.nix`](../nixos/homeserver/searx.nix)                       | [:closed_book: docs](https://docs.searxng.org/), [:gear: repo](https://github.com/searxng/searxng)                                                                                 | Self-hosted metasearch engine                                         |
| tinyMediaManager  | [`tinymediamanager.nix`](../nixos/homeserver/tinymediamanager.nix) | [:earth_asia: website](https://www.tinymediamanager.org/), [:closed_book: docs](https://www.tinymediamanager.org/docs/)                                                            | Media management                                                      |

### PostgreSQL

Used by the following services:

- Forgejo
- Invidious
- Nextcloud
- Paperless

### Nextcloud

The `occ` command to manage Nextcloud can be run via:

```bash
sudo -u nextcloud -g nextcloud nextcloud-occ <args>
```

### Paperless

The paperless management utilities (see [Paperless documentation](https://docs.paperless-ngx.com/administration/#management-commands)) can be run via:

```bash
sudo -u paperless -g paperless /var/lib/paperless/paperless-manage <program> <args>
```

Example:

```bash
sudo -u paperless -g paperless /var/lib/paperless/paperless-manage document_sanity_checker -v 3
```

## ZFS Filesystem

Each self-hosted service that needs persistent storage on disk gets its own ZFS dataset `rpool/<service>` which is mounted at the corresponding location, typically `/var/lib/<service>`.

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

The backup datasets `tankX/backups<service>` are created automatically by Syncoid.
