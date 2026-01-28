#!/usr/bin/env bash
set -euo pipefail

echo "[1] Проверка зависимостей..."
command -v kubectl >/dev/null
command -v velero >/dev/null

CRED_FILE="credentials-velero"
if [[ ! -f "$CRED_FILE" ]]; then
  echo "Файл $CRED_FILE не найден. Скопируй credentials-velero.example -> credentials-velero и заполни ключи."
  exit 1
fi

echo "[2] Namespace velero..."
kubectl get ns velero >/dev/null 2>&1 || kubectl create namespace velero

# Endpoint MinIO внутри кластера
MINIO_SVC_URL="${MINIO_SVC_URL:-http://minio.minio.svc.cluster.local:9000}"
BUCKET="${BUCKET:-velero}"

echo "[3] Установка Velero..."
velero install \
  --namespace velero \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.12.2 \
  --bucket "$BUCKET" \
  --secret-file "./$CRED_FILE" \
  --backup-location-config region=minio,s3ForcePathStyle=true,s3Url="$MINIO_SVC_URL" \
  --use-node-agent \
  --use-volume-snapshots=false

echo "[4] Ожидание готовности..."
kubectl -n velero rollout status deploy/velero --timeout=180s
kubectl -n velero get pods

echo "[5] Проверка backup-location..."
velero backup-location get

echo "Velero установлен."
