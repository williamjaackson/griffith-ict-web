#!/usr/bin/env bash
set -euo pipefail

echo "==> Stopping all preview services"
mapfile -t services < <(systemctl list-units --type=service --all --plain --no-legend 'griffith-preview@*.service' | awk '{print $1}')
for svc in "${services[@]}"; do
  echo "    Stopping $svc"
  systemctl stop "$svc" || true
  systemctl disable "$svc" || true
done

echo "==> Removing nginx preview configs"
disabled_directory=$(mktemp -d)
while IFS= read -r config; do
  if [[ $(basename "$config") =~ ^preview-pr-[1-9][0-9]*\.conf$ ]]; then
    mv "$config" "$disabled_directory/"
  fi
done < <(find /etc/nginx/conf.d -mindepth 1 -maxdepth 1 -type f -name 'preview-pr-*.conf' -print)

if nginx -t && systemctl reload nginx; then
  rm -rf -- "$disabled_directory"
else
  find "$disabled_directory" -mindepth 1 -maxdepth 1 -type f -exec mv -t /etc/nginx/conf.d -- {} +
  nginx -t && systemctl reload nginx || true
  echo "Nginx rejected the teardown; restored preview configs" >&2
  exit 1
fi

echo "==> Removing preview directories"
while IFS= read -r directory; do
  if [[ $(basename "$directory") =~ ^pr-[1-9][0-9]*$ ]]; then
    rm -rf -- "$directory"
  fi
done < <(find /opt/previews -mindepth 1 -maxdepth 1 -type d -name 'pr-*' -print)

echo "==> Cleaning up systemd overrides"
while IFS= read -r directory; do
  if [[ $(basename "$directory") =~ ^griffith-preview@[1-9][0-9]*\.service\.d$ ]]; then
    rm -rf -- "$directory"
  fi
done < <(find /etc/systemd/system -mindepth 1 -maxdepth 1 -type d -name 'griffith-preview@*.service.d' -print)
systemctl daemon-reload

echo "Done. All previews torn down."
