#!/usr/bin/env bash
set -euo pipefail

echo "==> Stopping all preview services"
for svc in $(systemctl list-units --type=service --all | grep griffith-preview@ | awk '{print $1}'); do
  echo "    Stopping $svc"
  systemctl stop "$svc" || true
  systemctl disable "$svc" || true
done

echo "==> Removing nginx preview configs"
rm -f /etc/nginx/conf.d/preview-pr-*.conf
nginx -t && systemctl reload nginx

echo "==> Removing preview directories"
rm -rf /opt/previews/pr-*

echo "==> Cleaning up systemd overrides"
rm -rf /etc/systemd/system/griffith-preview@*.service.d
systemctl daemon-reload

echo "Done. All previews torn down."
