# Haq — Server (Docker stack on EC2)

Three containers behind a single Caddy reverse proxy: n8n (orchestration), pdf (Flask + reportlab PDF generator), caddy (auto-HTTPS via Let's Encrypt).

## Prerequisites
- EC2 instance provisioned via `../infra/` (Docker pre-installed)
- A Supabase project with the schema applied (see `../db/schema.sql`)
- A DuckDNS (or any DNS) subdomain pointing at your EC2 Elastic IP, e.g. `haq.duckdns.org` — needed for HTTPS

## First-time setup on the server

1. SSH in:
   ```bash
   ssh -i haq-key.pem ubuntu@<ec2_public_ip>
   ```
2. Copy this `server/` directory to `~/haq/` on the EC2 box (e.g. via `scp -r server ubuntu@<ip>:~/haq` from your laptop).
3. Copy the examples to real configs and fill in your values:
   ```bash
   cd ~/haq
   cp docker-compose.example.yml docker-compose.yml
   cp Caddyfile.example Caddyfile
   nano docker-compose.yml    # fill Supabase host/user/password + your DNS subdomain
   nano Caddyfile             # replace placeholder with your DNS subdomain
   ```
4. Bring it up:
   ```bash
   docker compose up -d
   ```
5. Watch logs for Caddy obtaining the TLS certificate (~30 sec):
   ```bash
   docker compose logs caddy | grep certificate
   ```

## Verify
- `https://<your-subdomain>` → n8n login page (HTTPS green padlock)
- `http://<ec2_public_ip>:3200/health` → `{"ok": true, "service": "haq-pdf", ...}`

## Next
- Import the n8n workflows from `../workflows/` and follow `../workflows/README.md`.
- Seed schemes via `../db/scheme_seed_pack.sql`.

## Stack notes
- **n8n** stores all workflows/credentials/users in Supabase Postgres (configured via env vars).
- **pdf** is a Flask service exposing `POST /fill` which returns a branded pre-filled PDF; it auto-pip-installs on first start.
- **caddy** proxies `https://<subdomain>` → `n8n:5678` and handles Let's Encrypt automatically.
