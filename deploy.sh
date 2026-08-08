#!/bin/bash
# Deployment script for TheGenies (git-pull pattern like TheUSDX + static nginx like Granular)
# Usage: ./deploy.sh
#
# Expects the repo already cloned once on the server:
#   git clone git@github.com:mickeyshaughnessy/TheGenies.git /var/www/TheGenies
# Or HTTPS:
#   git clone https://github.com/mickeyshaughnessy/TheGenies.git /var/www/TheGenies
set -euo pipefail

SERVER="${SERVER:-root@143.110.131.237}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519}"
DEPLOY_PATH="/var/www/TheGenies"
NGINX_SITE="/etc/nginx/sites-enabled/themithrilcompany.com"
REPO_URL="${REPO_URL:-https://github.com/mickeyshaughnessy/TheGenies.git}"
ROOT="$(cd "$(dirname "$0")" && pwd)"
SSH=(ssh -i "$SSH_KEY" -o BatchMode=yes "$SERVER")

echo "═══════════════════════════════════════════"
echo " TheGenies → $SERVER:$DEPLOY_PATH"
echo "═══════════════════════════════════════════"

# 1. Pull latest code on server (TheUSDX-style)
echo "Pulling latest code..."
"${SSH[@]}" bash -s <<ENDSSH
set -euo pipefail
if [ ! -d "$DEPLOY_PATH/.git" ]; then
  echo "Cloning $REPO_URL → $DEPLOY_PATH"
  mkdir -p "$(dirname "$DEPLOY_PATH")"
  git clone "$REPO_URL" "$DEPLOY_PATH"
else
  cd "$DEPLOY_PATH"
  git stash 2>/dev/null || true
  git fetch origin
  git checkout main 2>/dev/null || git checkout master 2>/dev/null || true
  git pull --ff-only origin main 2>/dev/null || git pull --ff-only origin master
  git stash pop 2>/dev/null || true
fi
cd "$DEPLOY_PATH"
echo "Code updated: \$(git rev-parse --short HEAD)"
ls -la "$DEPLOY_PATH"
ENDSSH

# 2. Install / refresh nginx location block (Granular-style static paths)
SNIPPET_LOCAL="$ROOT/deploy/nginx-genies.snippet"
if [ ! -f "$SNIPPET_LOCAL" ]; then
  echo "ERROR: missing $SNIPPET_LOCAL" >&2
  exit 1
fi

echo "Updating nginx locations in $NGINX_SITE …"
scp -i "$SSH_KEY" -o BatchMode=yes "$SNIPPET_LOCAL" "$SERVER:/tmp/nginx-genies.snippet"

"${SSH[@]}" bash -s <<'ENDSSH'
set -euo pipefail
SITE=/etc/nginx/sites-enabled/themithrilcompany.com
SNIP=/tmp/nginx-genies.snippet
mkdir -p /etc/nginx/bak
cp -a "$SITE" "/etc/nginx/bak/themithrilcompany.com.bak.genies.$(date +%Y%m%d%H%M%S)"
rm -f /etc/nginx/sites-enabled/themithrilcompany.com.bak.* 2>/dev/null || true

python3 - <<'PY'
from pathlib import Path
import re

site = Path("/etc/nginx/sites-enabled/themithrilcompany.com")
snip = Path("/tmp/nginx-genies.snippet").read_text()
text = site.read_text()

text2 = re.sub(
    r"\n?# BEGIN TheGenies.*?# END TheGenies\n?",
    "\n",
    text,
    flags=re.S,
)

marker = "    location / {"
idx = text2.find(marker)
if idx == -1:
    marker = "    listen 443 ssl"
    idx = text2.find(marker)
if idx == -1:
    raise SystemExit("Could not find insertion point in nginx site config")

block = "\n" + snip.rstrip() + "\n\n"
text2 = text2[:idx] + block + text2[idx:]
site.write_text(text2)
print("Nginx site updated with TheGenies locations")
PY

nginx -t
systemctl reload nginx
echo "nginx reloaded OK"
ENDSSH

echo ""
echo "Deployed."
echo "  https://themithrilcompany.com/genies/"
echo "  https://themithrilcompany.com/genies.html"
