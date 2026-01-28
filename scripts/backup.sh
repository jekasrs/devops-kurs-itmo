#!/usr/bin/env bash
set -euo pipefail

command -v velero >/dev/null

BACKUP_NAME="${1:-prod-manual-001}"

echo "Создание бэкапа: $BACKUP_NAME ..."
velero backup create "$BACKUP_NAME" \
  --include-namespaces prod \
  --ttl 336h0m0s \
  --default-volumes-to-fs-backup \
  --exclude-resources secrets

echo "Ожидание завершения..."
# простой wait-пулл
for i in {1..60}; do
  STATUS="$(velero backup get "$BACKUP_NAME" -o jsonpath='{.status.phase}' 2>/dev/null || true)"
  [[ "$STATUS" == "Completed" ]] && break
  [[ "$STATUS" == "Failed" ]] && { echo "Backup Failed"; exit 1; }
  sleep 5
done

echo "Результат:"
velero backup get "$BACKUP_NAME"
velero backup describe "$BACKUP_NAME" --details
