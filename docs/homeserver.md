# Homeserver

## Hosted Services

| Name             | Links                                                                                                                                                                              | Purpose                                                               |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| audiobookshelf   | [:earth_asia: website](https://www.audiobookshelf.org/), [:closed_book: docs](https://www.audiobookshelf.org/docs), [:gear: repo](https://github.com/advplyr/audiobookshelf)       | Streaming audiobooks                                                  |
| Forgejo          | [:earth_asia: website](https://forgejo.org/), [:closed_book: docs](https://forgejo.org/docs/latest/), [:gear: repo](https://codeberg.org/forgejo/forgejo)                          | Git forge, mostly for backups via gickup (see below)                  |
| Gickup           | [:closed_book: docs](https://cooperspencer.github.io/gickup-documentation/), [:gear: repo](https://github.com/cooperspencer/gickup)                                                | Backing up git repositories                                           |
| Homepage         | [:earth_asia: website](https://gethomepage.dev/), [:closed_book: docs](https://gethomepage.dev/widgets/), [:gear: repo](https://github.com/gethomepage/homepage)                   | Dashboard for quick access and overview over hosted services          |
| Invidious        | [:earth_asia: website](https://invidious.io/), [:closed_book: docs](https://docs.invidious.io/), [:gear: repo](https://github.com/iv-org/invidious)                                | Watching YouTube with less nonsense                                   |
| Jellyfin         | [:earth_asia: website](https://jellyfin.org/), [:closed_book: docs](https://jellyfin.org/docs/), [:gear: repo](https://github.com/jellyfin/jellyfin)                               | Movie/TV show streaming                                               |
| Navidrome        | [:earth_asia: website](https://www.navidrome.org/), [:closed_book: docs](https://www.navidrome.org/docs/), [:gear: repo](https://github.com/navidrome/navidrome)                   | Music streaming                                                       |
| Nextcloud        | [:earth_asia: website](https://nextcloud.com/), [:closed_book: docs](https://docs.nextcloud.com/server/latest/admin_manual/), [:gear: repo](https://github.com/nextcloud/server)   | Groupware server hosting files, contacts, calendars, tasks, etc.      |
| Nginx            | [:earth_asia: website](https://nginx.org/en/), [:closed_book: docs](https://nginx.org/en/docs/), [:gear: repo](https://github.com/nginx/nginx)                                     | Reverse proxy for self-hosted services, does SSL termination          |
| Paperless        | [:closed_book: docs](https://docs.paperless-ngx.com/), [:gear: repo](https://github.com/paperless-ngx/paperless-ngx)                                                               | Document management, archival, and OCR                                |
| PostgreSQL       | [:earth_asia: website](https://www.postgresql.org/), [:closed_book: docs](https://www.postgresql.org/docs/current/index.html), [:gear: repo](https://github.com/postgres/postgres) | Database backend for various services (see [PostgreSQL](#postgresql)) |
| Samba            | [:earth_asia: website](https://www.samba.org/), [:closed_book: docs](https://www.samba.org/samba/docs/), [:gear: repo](https://gitlab.com/samba-team/samba)                        | File server                                                           |
| SearXNG          | [:closed_book: docs](https://docs.searxng.org/), [:gear: repo](https://github.com/searxng/searxng)                                                                                 | Self-hosted metasearch engine                                         |
| tinyMediaManager | [:earth_asia: website](https://www.tinymediamanager.org/), [:closed_book: docs](https://www.tinymediamanager.org/docs/)                                                            | Media management                                                      |

## PostgreSQL

Used by the following services:

- Forgejo
- Invidious
- Nextcloud
- Paperless

# Images

## VM Image for Downloader

```shell
nix run github:nix-community/nixos-generators -- --flake ".#downloader" -f qcow
```

# Firefox Settings

## GUI

- Enable `General > Always ask you where to save files`
- Enable `General > Play DRM-controlled content`

## `about:config`

### Compact Mode

`browser.compactmode.show = true`

Right-click on the toolbar and select `Customize Toolbar...`. At the bottom under `Density` select `Compact`.

## Environment Variables

### Wayland Mode

`MOZ_ENABLE_WAYLAND=1`

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
