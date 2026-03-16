# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository builds and deploys a containerized [Foswiki](https://foswiki.org/) wiki (v2.1.10) using Alpine Linux, Nginx, FastCGI, and Apache Solr for full-text search. The resulting image is ~400MB.

## Common Commands

### Build the image
```bash
docker build --no-cache -t docker-foswiki .
```

### Start/stop services
```bash
docker-compose up -d
docker-compose down
docker-compose logs -f foswiki
```

### Access the running container
```bash
docker exec -it foswiki /bin/bash
```

### Reset Foswiki admin password
```bash
docker exec -it foswiki /bin/bash -c \
  "cd /var/www/foswiki && tools/configure -save -set {Password}='NewPassword'"
```

### Generate a self-signed SSL cert (for HTTPS variant)
```bash
openssl req -x509 -newkey rsa:4096 -nodes \
  -keyout https/docker-foswiki.key \
  -out https/docker-foswiki.crt -days 365
```

### Renew Let's Encrypt certificate
```bash
./cert-renew.sh
```

## Architecture

### Container internals (`docker-entrypoint.sh`)
1. Links Foswiki's Solr config into the Solr container's expected path
2. Configures SolrPlugin to use the internal `solr` hostname
3. Enables NatSkin as default skin
4. Starts `iwatch` daemon — monitors `/var/www/foswiki/data` for `.txt` file changes and triggers `tools/solrjob` for automatic indexing
5. Starts Foswiki FastCGI daemon (5 workers on `127.0.0.1:9000`)
6. Starts Nginx in the foreground

### Service topology (docker-compose.yml)
- **foswiki** — Alpine-based container running Nginx + FastCGI
- **solr** — Apache Solr 5 for search
- Networks: `frontend` (exposed) and `backend` (internal only)
- Foswiki waits for Solr to pass its health check before starting

### Docker Compose variants
| File | Purpose |
|---|---|
| `docker-compose.yml` | Active config (copy from a variant below) |
| `docker-compose.1-simple.yml` | HTTP only, port 8765 |
| `docker-compose.2-simple-https.yml` | HTTP + HTTPS (8765/8443) |
| `docker-compose.3-multipleInstances.yml` | Multiple instances with distinct ports |
| `docker-compose.4-Traefik.yml` | Traefik reverse proxy integration |

### Key config files
- **`Dockerfile`** — builds the image; defines Foswiki version + SHA1, all Alpine packages, and the 40+ pre-installed Foswiki plugins
- **`nginx.default.conf`** — Nginx config: short-URL rewriting, FastCGI proxy (`127.0.0.1:9000`), X-Accel-Redirect for static files, 50MB upload limit, security directory blocks
- **`iwatch.xml`** — iwatch file monitoring config; triggers Solr indexing on data changes
- **`.env`** — `COMPOSE_PROJECT_NAME`, `EXTERNAL_PORT`, `TZ`, `URL`, `ACME` (Traefik resolver)

### Foswiki inside the container
- Root: `/var/www/foswiki/`
- Data: `/var/www/foswiki/data/`
- Solr configsets are symlinked between the Foswiki and Solr containers via a shared volume

## Upgrading Foswiki
Update `FOSWIKI_VERSION` and `FOSWIKI_SHA1` in the `Dockerfile`, then rebuild. See `CHANGES` for version history.

## CapRover deployment
See `README-CAPROVER.md` and `foswiki.json` (one-click app definition).
