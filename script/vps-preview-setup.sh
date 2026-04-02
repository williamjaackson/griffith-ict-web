#!/usr/bin/env bash
set -euo pipefail

echo "==> Creating preview directory"
mkdir -p /opt/previews

echo "==> Generating shared SECRET_KEY_BASE"
if [ ! -f /opt/previews/.secret_key_base ]; then
  openssl rand -hex 64 > /opt/previews/.secret_key_base
  chmod 600 /opt/previews/.secret_key_base
  echo "    Created /opt/previews/.secret_key_base"
else
  echo "    Already exists, skipping"
fi

echo "==> Installing systemd template unit"
cat > /etc/systemd/system/griffith-preview@.service <<'EOF'
[Unit]
Description=Griffith ICT Web Preview (PR %i)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/previews/pr-%i
Environment="RAILS_ENV=production"
ExecStart=/bin/bash -c 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH" && exec bundle exec puma -C config/puma.rb'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
echo "    Installed griffith-preview@.service template"

echo "==> Creating nginx conf.d directory"
mkdir -p /etc/nginx/conf.d

echo ""
echo "=== MANUAL STEPS REMAINING ==="
echo ""
echo "1. DNS: Add a wildcard A record for *.griffithict.club"
echo "   pointing to this server's IP address (Cloudflare)."
echo ""
echo "2. SSL: Cloudflare Universal SSL covers *.griffithict.club."
echo "   Ensure the wildcard DNS record is proxied (orange cloud)."
echo "   Set SSL mode to Full (strict) and use a Cloudflare Origin CA cert on the VPS."
echo ""
echo "3. Ensure nginx includes conf.d/*.conf in its http block:"
echo "   include /etc/nginx/conf.d/*.conf;"
echo ""
echo "4. Create a 'preview' label in the GitHub repository."
echo ""
echo "Setup complete."
